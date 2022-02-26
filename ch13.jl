# Bogumił Kamiński, 2022

# Codes for chapter 13

# Codes for section 13.1

using CSV
using CategoricalArrays
using DataFrames
using DataFramesMeta
using Dates
using Distributions
import Downloads
using FreqTables
using GLM
using Plots
using Random
using ROCAnalysis
using SHA
using Statistics
import ZipFile

url_zip = "https://stacks.stanford.edu/file/druid:yg821jf8611/" *
          "yg821jf8611_ky_owensboro_2020_04_01.csv.zip";
local_zip = "owensboro.zip";
isfile(local_zip) || Downloads.download(url_zip, local_zip)
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
owensboro = @chain archive begin
    only(_.files)
    read
    CSV.read(DataFrame; missingstring="NA")
end;
close(archive)

summary(owensboro)
describe(owensboro, :nunique, :nmissing, :eltype)

# Code for listing 13.1

select!(owensboro, :date, :type, :arrest_made, :violation);
summary(owensboro)
describe(owensboro, :nunique, :nmissing, :eltype)

# Code for listing 13.2

df = DataFrame(id=[1, 2, 1, 2], v=1:4)
combine(df, :v => sum => :sum)
transform(df, :v => sum => :sum)
select(df, :v => sum => :sum)
gdf = groupby(df, :id)
combine(gdf, :v => sum => :sum)
transform(gdf, :v => sum => :sum)
select(gdf, :v => sum => :sum)

# Code for listing 13.3

select(df,
    :v => identity => :v1,
    :v => identity,
    :v => :v2,
    :v)

# Codes for section 13.2

owensboro.violation

# Code for listing 13.4

violation_list = [strip.(split(x, ";"))
                  for x in owensboro.violation]
violation_flat = reduce(vcat, violation_list)
violation_flat_clean = [contains(x, "SPEEDING") ?
                        "SPEEDING" : x for x in violation_flat]
sort(freqtable(violation_flat_clean), rev=true)

# Code for listing 13.5

agg_violation = @chain owensboro begin
    select(:violation =>
           ByRow(x -> strip.(split(x, ";"))) =>
           :v)
    flatten(:v)
    select(:v =>
           ByRow(x -> contains(x, "SPEEDING") ? "SPEEDING" : x) =>
           :v)
    groupby(:v)
    combine(nrow => :count)
    sort(:count, rev=true)
end

# Code explaining ByRow

sqrt(4)
sqrt([4, 9, 16])
ByRow(sqrt)([4, 9, 16])
f = ByRow(sqrt)
f([4, 9, 16])

# Code explaining flatten

df = DataFrame(id=1:2, v=[[11, 12], [13, 14, 15]])
flatten(df, :v)

# Code explaining nrow

@chain DataFrame(id=[1, 1, 2, 2, 2]) begin
    groupby(:id)
    combine(nrow, nrow => :rows)
end

# Code explaining sort

df = DataFrame(a=[2, 1, 2, 1, 2], b=5:-1:1)
sort(df, :b)
sort(df, [:a, :b])

# Code showing an example transformation

df = DataFrame(x=[4, 9, 16])
transform(df, :x => ByRow(sqrt))

# Code showing usage of DataFramesMeta.jl

@chain owensboro begin
    @rselect(:v=strip.(split(:violation, ";")))
    flatten(:v)
    @rselect(:v=contains(:v, "SPEEDING") ?
                         "SPEEDING" : :v)
    groupby(:v)
    combine(nrow => :count)
    sort(:count, rev=true)
end

# Code showing comparison of DataFramesMeta.jl vs DataFrames.jl

df = DataFrame(x=[4, 9, 16])
@select(df, :s = sqrt.(:x))
@rselect(df, :s = sqrt(:x))
select(df, :x => ByRow(sqrt) => :s)

# Codes for section 13.3

# Code for listing 13.6

owensboro2 = select(owensboro,
    :arrest_made => :arrest,
    :date => ByRow(dayofweek) => :day,
    :type,
    [:violation =>
     ByRow(x -> contains(x, agg_violation.v[i])) =>
     "v$i" for i in 1:4])

# Code explaining programmatic generation of transformations

[:violation =>
 ByRow(x -> contains(x, agg_violation.v[i])) =>
 "v$i" for i in 1:4]

combine(owensboro, [:date :arrest_made] .=> [minimum, maximum])
[:date :arrest_made] .=> [minimum, maximum]

# Code for listing 13.7

weekdays = DataFrame(day=1:7,
                     dayname=categorical(dayname.(1:7); ordered=true))
isordered(weekdays.dayname)
levels(weekdays.dayname)
levels!(weekdays.dayname, weekdays.dayname)

# Code showing join operation

leftjoin!(owensboro2, weekdays; on=:day)

# Code for listing 13.8

@chain owensboro2 begin
    groupby([:day, :dayname]; sort=true)
    combine(nrow)
end

# Code showing creation of frequency table from a data frame

freqtable(owensboro2, :dayname, :day)

# Code for listing 13.9

@chain owensboro2 begin
    groupby([:day, :dayname]; sort=true)
    combine(nrow)
    unstack(:dayname, :day, :nrow; fill=0)
end

# Code for dropping rows with missing data

dropmissing!(owensboro2)

# Code for dropping unwanted column

select!(owensboro2, Not(:day))

# Codes for section 13.4

# Code for listing 13.10

Random.seed!(1234);
owensboro2.train = rand(Bernoulli(0.7), nrow(owensboro2));
mean(owensboro2.train)

# Code for listing 13.11

train = subset(owensboro2, :train)
test = subset(owensboro2, :train => ByRow(!))

# Code showing subsetting with DataFramesMeta.jl

@rsubset(owensboro2, !(:train))

# Code building a predictive model

model = glm(@formula(arrest~dayname+type+v1+v2+v3+v4),
            train, Binomial(), LogitLink())

# Code for making predictions

train.predict = predict(model)
test.predict = predict(model, test)

# Code for producing histograms showing predictions

test_groups = groupby(test, :arrest);
histogram(test_groups[(false,)].predict;
          bins=10, normalize=:probability,
          fillstyle= :/, label="false")
histogram!(test_groups[(true,)].predict;
           bins=10, normalize=:probability,
           fillalpha=0.5, label="true")

# Code for computing of confusion matrix

@chain test begin
    @rselect(:predicted=:predict > 0.15, :observed=:arrest)
    proptable(:predicted, :observed; margins=2)
end

# Code for listing 13.12

test_roc =  roc(test; score=:predict, target=:arrest)
plot(test_roc.pfa, test_roc.pmiss;
     color="black", lw=3,
     label="test (AUC=$(round(100*auc(test_roc), digits=2))%)",
     xlabel="pfa", ylabel="pmiss")
train_roc =  roc(train, score=:predict, target=:arrest)
plot!(train_roc.pfa, train_roc.pmiss;
      color="gold", lw=3,
      label="train (AUC=$(round(100*auc(train_roc), digits=2))%)")

# Codes for section 13.5

DataFrame(:a=>1, :a=>2)

DataFrame(:a=>1, :a=>2; makeunique=true)
