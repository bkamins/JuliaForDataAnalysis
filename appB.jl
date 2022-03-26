# Bogumił Kamiński, 2021

# Codes for appendix B

# the solutions for exercises from a given chapter assume that
# there are packages loaded, variables and functions defined in the user's
# Julia session in a state that reflects the point of computations
# at the position of the chapter where a given exercise is formulated

# Code for exercise 3.1

using BenchmarkTools
x = 1:10^6;
y = collect(x);
@btime sort($x);
@btime sort($y);
@edit sort(x)

# Code for exercise 4.1

using Statistics
using BenchmarkTools
aq = [10.0   8.04  10.0  9.14  10.0   7.46   8.0   6.58
       8.0   6.95   8.0  8.14   8.0   6.77   8.0   5.76
      13.0   7.58  13.0  8.74  13.0  12.74   8.0   7.71
       9.0   8.81   9.0  8.77   9.0   7.11   8.0   8.84
      11.0   8.33  11.0  9.26  11.0   7.81   8.0   8.47
      14.0   9.96  14.0  8.1   14.0   8.84   8.0   7.04
       6.0   7.24   6.0  6.13   6.0   6.08   8.0   5.25
       4.0   4.26   4.0  3.1    4.0   5.39  19.0  12.50
      12.0  10.84  12.0  9.13  12.0   8.15   8.0   5.56
       7.0   4.82   7.0  7.26   7.0   6.42   8.0   7.91
       5.0   5.68   5.0  4.74   5.0   5.73   8.0   6.89];
@benchmark [cor($aq[:, i], $aq[:, i+1]) for i in 1:2:7]
@benchmark [cor(view($aq, :, i), view($aq, :, i+1)) for i in 1:2:7]

# Code for exercise 4.2

function dice_distribution(dice1, dice2)
    distribution = Dict{Int, Int}()
    for i in dice1
        for j in dice2
            s = i + j
            if haskey(distribution, s)
                distribution[s] += 1
            else
                distribution[s] = 1
            end
        end
    end
    return distribution
end

function test_dice()
    all_dice = [[1, x2, x3, x4, x5, x6]
                for x2 in 2:11
                for x3 in x2:11
                for x4 in x3:11
                for x5 in x4:11
                for x6 in x5:11]

    two_standard = dice_distribution(1:6, 1:6)

    for d1 in all_dice, d2 in all_dice
        test = dice_distribution(d1, d2)
        if test == two_standard
            println(d1, " ", d2)
        end
    end
end

test_dice()

# Code for exercise 4.3

plot(scatter(data.set1.x, data.set1.y; legend=false),
     scatter(data.set2.x, data.set2.y; legend=false),
     scatter(data.set3.x, data.set3.y; legend=false),
     scatter(data.set4.x, data.set4.y; legend=false))

# Code for exercise 5.1

parse.(Int, ["1", "2", "3"])

# Code for exercise 5.2

Random.seed!(1234);
data5bis = [randn(100, 5) .- 0.4; randn(100, 5) .+ 0.4];
tsne = manifold.TSNE(n_components=2, init="random",
                     learning_rate="auto", random_state=1234);
data2bis = tsne.fit_transform(data5bis);
scatter(data2bis[:, 1], data2bis[:, 2];
        color=[fill("black", 100); fill("gold", 100)],
        legend=false)

# Code for exercise 6.1

years_table = freqtable(years)
plot(names(years_table, 1), years_table; legend=false,
           xlabel="year", ylabel="# of movies")


# Code for exercise 6.2

s3 = Symbol.(s1)
@btime sort($s3);
@btime unique($s1);
@btime unique($s2);
@btime unique($s3);

# Code for exercise 7.1

v = ["1", "2", missing, "4"]
[ismissing(x) ? missing : parse(Int, x) for x in v]
map(v) do x
    if ismissing(x)
        return missing
    else
        return parse(Int, x)
    end
end
using Missings
passmissing(parse).(Int, v)

# Code for exercise 7.2

using Dates
Date(2021, 1, 1):Month(1):Date(2021, 12, 1)
collect(Date(2021, 1, 1):Month(1):Date(2021, 12, 1))

# Code for exercise 8.1

using BenchmarkTools
@btime $puzzles."Rating";

# Code for exercise 9.1

using StatsBase
summarystats(puzzles[puzzles.Popularity .== 100, "NbPlays"])
summarystats(puzzles[puzzles.Popularity .== -100, "NbPlays"])

# Code for exercise 9.2

sum(length, values(rating_mapping))
nrow(good)

# Code for exercise 10.1

using BenchmarkTools
x = rand(10^6);
@btime DataFrame(x=$x);
@btime DataFrame(x=$x; copycols=false);

# Code for exercise 10.2

df1 = DataFrame(a=1,b=2)
df2 = DataFrame(b=3, a=4)
vcat(df1, df2)
vcat(df1, df2, cols=:orderequal)

# Code for exercise 10.3

function walk_unique_2ahead()
    walk = DataFrame(x=0, y=0)
    for _ in 1:10
        current = walk[end, :]
        push!(walk, sim_step(current))
    end
    return all(walk[i, :] != walk[i+2, :] for i in 1:9)
end
Random.seed!(2);
proptable([walk_unique_2ahead() for _ in 1:10^5])

# Code for exercise 11.1

@time wide = DataFrame(ones(1, 10_000), :auto);
@time Tables.columntable(wide);

# Code for exercise 11.2

using Statistics
Dict(key.city => mean(df.rainfall) for (key, df) in pairs(gdf_city))
combine(gdf_city, :rainfall => mean)

# Code for exercise 12.1

cg = complete_graph(37700)
Base.summarysize(cg)
@time deg_class(cg, classes_df.ml_target);

# Code for exercise 12.2

scatter(log1p.(agg_df.deg_ml),
        log1p.(agg_df.deg_web);
        zcolor=agg_df.web_mean,
        xlabel="degree ml", ylabel="degree web",
        markersize=2, markerstrokewidth=0, markeralpha=0.8,
        legend=:topleft, labels = "fraction web",
        xticks=gen_ticks(maximum(classes_df.deg_ml)),
        yticks=gen_ticks(maximum(classes_df.deg_web)))

# Code for exercise 12.3

glm(@formula(ml_target~log1p(deg_ml)+log1p(deg_web)),
    classes_df, Binomial(), ProbitLink())

# Code for exercise 12.4

df = DataFrame()
df.a = [1, 2, 3]
df.b = df.a
df.b === df.a
df.b = df[:, "b"]
df.b === df.a
df.b == df.a
df[1:2, "a"] .= 10
df

# Code for exercise 13.1

@rselect(owensboro,
    :arrest = :arrest_made,
    :day = dayofweek(:date),
    :type,
    :v1 = contains(:violation, agg_violation.v[1]),
    :v2 = contains(:violation, agg_violation.v[2]),
    :v3 = contains(:violation, agg_violation.v[3]),
    :v4 = contains(:violation, agg_violation.v[4]))

# Code for exercise 13.2

select(owensboro,
    :arrest_made => :arrest,
    :date => ByRow(dayofweek) => :day,
    :type,
    [:violation =>
     ByRow(x -> contains(x, agg_violation.v[i])) =>
     "v$i" for i in 1:4],
    :date => ByRow(dayname) => :dayname)

# Code for exercise 13.3

@chain owensboro2 begin
    groupby(:dayname, sort=true)
    combine(:arrest => mean)
end

@chain owensboro2 begin
    groupby([:dayname, :type], sort=true)
    combine(:arrest => mean)
    unstack(:dayname, :type, :arrest_mean)
end

# Code for exercise 13.4

train2 = owensboro2[owensboro2.train, :]
test2 = owensboro2[.!owensboro2.train, :]
test3, train3 = groupby(owensboro2, :train, sort=true)

# Code for exercise 14.1

@time mean(x -> x < 0, -10^6:10^6)
@time mean(x -> x < 0, -10^6:10^6)
@time mean(x -> x < 0, -10^6:10^6)
@time mean(<(0), -10^6:10^6)
@time mean(<(0), -10^6:10^6)
@time mean(<(0), -10^6:10^6)

lt0(x) = x < 0
@time mean(lt0, -10^6:10^6)
@time mean(lt0, -10^6:10^6)
@time mean(lt0, -10^6:10^6)

# Code for exercise 14.2

# web service code

using Genie
Genie.config.run_as_server = true
Genie.Router.route("/", method=POST) do
    message = Genie.Requests.jsonpayload()
    return try
        n = message["n"]
        Genie.Renderer.Json.json(rand(n))
    catch
        Genie.Responses.setstatus(400)
    end
end
Genie.startup()

# client code

using HTTP
using JSON3
req = HTTP.post("http://127.0.0.1:8000",
                ["Content-Type" => "application/json"],
                JSON3.write((n=3,)))
JSON3.read(req.body)
HTTP.post("http://127.0.0.1:8000",
                ["Content-Type" => "application/json"],
                JSON3.write((x=3,)))
