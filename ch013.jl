using CSV
using DataFrames
using DataFramesMeta
using Dates
import Downloads
using GLM
using Plots
using Random
using SHA
using Statistics
import ZipFile

url_zip = "https://stacks.stanford.edu/file/druid:yg821jf8611/" *
          "yg821jf8611_ky_owensboro_2020_04_01.csv.zip"
local_zip = "owensboro.zip"

isfile(url_zip) || Downloads.download(url_zip, local_zip)
isfile(local_zip)
open(sha256, local_zip) == [0x14, 0x3b, 0x7d, 0x74,
                            0xbc, 0x15, 0x74, 0xc5,
                            0xf8, 0x42, 0xe0, 0x3f,
                            0x8f, 0x08, 0x88, 0xd5,
                            0xe2, 0xa8, 0x13, 0x24,
                            0xfd, 0x4e, 0xab, 0xde,
                            0x02, 0x89, 0xdd, 0x74,
                            0x3c, 0xb3, 0x5d, 0x56]
archive = ZipFile.Reader(local_zip)
owensboro = CSV.read(read(only(archive.files)), DataFrame;
                     missingstring="NA")
close(archive)
describe(owensboro, :nunique, :nmissing, :eltype)

agg_violation = @chain owensboro begin
    @rselect(:violation = strip.(split(:violation, ";")))
    flatten(:violation)
    @rselect(:violation = contains(:violation, "SPEEDING") ? "SPEEDING" : :violation)
    groupby(:violation)
    combine(nrow)
    sort!(:nrow, rev=true)
end

top_violation = first(agg_violation.violation, 4)

owensboro2 = select(owensboro,
       :date => ByRow(dayofweek) => :day,
       :type,
       :arrest_made => :arrest,
       :violation =>
       ByRow(x -> contains.(x, top_violation)) =>
       [:v_belt, :v_ins, :v_plate, :v_speed])

# mention rename and rename!

# Exercise:
# select(owensboro,
# :date => ByRow(dayname) => :day, :type, :arrest_made => :arrest,
# :violation => ByRow(x -> contains.(x, top_violation)) =>
# [:v_belt, :v_ins, :v_plate, :v_speed])

using CategoricalArrays

weekdays = DataFrame(day=1:7,
                     dayname=categorical(dayname.(1:7), ordered=true))
levels(weekdays.dayname)
levels!(weekdays.dayname, weekdays.dayname)
levels(weekdays.dayname)
leftjoin!(owensboro2, weekdays, on=:day)
levels(owensboro2.dayname)

@chain owensboro2 begin
    groupby([:day, :dayname])
    combine(nrow)
end

@chain owensboro2 begin
    groupby([:day, :dayname])
    combine(nrow)
    unstack(:day, :dayname, :nrow)
end

# Alternative:
# unstack(owensboro2, :day, :dayname, :dayname, valuestransform=>length)

@chain owensboro2 begin
    combine(AsTable(r"v_") => sum => :total)
    groupby(:total)
    combine(nrow)
end

select!(owensboro2, :arrest, :dayname, Not(:day))
mapcols(x -> count(ismissing, x), owensboro2)
dropmissing!(owensboro2)
mapcols(x -> count(ismissing, x), owensboro2)
@chain owensboro2 begin
    groupby(:dayname, sort=true)
    combine(:arrest => mean)
    bar(_.dayname, _.arrest_mean, legend=false,
        xlabel="day of week", ylabel="probability of arrest")
end

using Distributions
Random.seed!(1234);
owensboro2.train = rand(Bernoulli(0.7), nrow(owensboro2));
mean(owensboro2.train)
test, train = groupby(owensboro2, :train, sort=true);

model = glm(@formula(arrest~dayname+type+v_belt+v_ins+v_plate+v_speed),
            train, Binomial(), LogitLink())

train.predict = predict(model);
test.predict = predict(model, test);

test_groups = groupby(test, :arrest)
histogram(test_groups[(false,)].predict;
          bins=10, normalize=:probability,
          fillalpha=0.5, label="false")
histogram!(test_groups[(true,)].predict;
           bins=10, normalize=:probability,
           fillalpha=0.5, label="true")

using ROCAnalysis
test_roc =  roc(test, score=:predict, target=:arrest)
plot(test_roc.pfa, 1 .- test_roc.pmiss;
     legend=:bottomright,
     color="black", lw=3,
     label="test (AUC=$(round(100*(1-auc(test_roc)), digits=2))%)",
     xlabel="FPR", ylabel="TPR")
train_roc =  roc(train, score=:predict, target=:arrest)
plot!(train_roc.pfa, 1 .- train_roc.pmiss;
     color="green", lw=3,
     label="train (AUC=$(round(100*(1-auc(train_roc)), digits=2))%)",)
