# Bogumił Kamiński, 2022

# Codes for chapter 12

# Codes for section 12.1

# Code for listing 12.1

import Downloads
using SHA
git_zip = "git_web_ml.zip"
if !isfile(git_zip)
    Downloads.download("https://snap.stanford.edu/data/" *
                       "git_web_ml.zip",
                       git_zip)
end
isfile(git_zip)
open(sha256, git_zip) == [0x56, 0xc0, 0xc1, 0xc2,
                          0xc4, 0x60, 0xdc, 0x4c,
                          0x7b, 0xf8, 0x93, 0x57,
                          0xb1, 0xfe, 0xc0, 0x20,
                          0xf4, 0x5e, 0x2e, 0xce,
                          0xba, 0xb8, 0x1d, 0x13,
                          0x1d, 0x07, 0x3b, 0x10,
                          0xe2, 0x8e, 0xc0, 0x31]

# Code for opening a zip archive

import ZipFile
git_archive = ZipFile.Reader(git_zip)

# Code for listing 12.2

function ingest_to_df(archive::ZipFile.Reader, filename::AbstractString)
    idx = only(findall(x -> x.name == filename, archive.files))
    return CSV.read(read(archive.files[idx]), DataFrame)
end

# Code for working with zip archive

git_archive.files

git_archive.files[2].name

findall(x -> x.name == "git_web_ml/musae_git_edges.csv", git_archive.files)
findall(x -> x.name == "", git_archive.files)

only(findall(x -> x.name == "git_web_ml/musae_git_edges.csv", git_archive.files))
only(findall(x -> x.name == "", git_archive.files))

# Code for listing 12.3

using CSV
using DataFrames
edges_df = ingest_to_df(git_archive, "git_web_ml/musae_git_edges.csv");
classes_df = ingest_to_df(git_archive, "git_web_ml/musae_git_target.csv");
close(git_archive)
summary(edges_df)
describe(edges_df, :min, :max, :mean, :nmissing, :eltype)
summary(classes_df)
describe(classes_df, :min, :max, :mean, :nmissing, :eltype)

# Code for updating data frame columns using broadcasting

edges_df .+= 1
classes_df.id .+= 1

# Code for examples of data frame broadcasting

df = DataFrame(a=1:3, b=[4, missing, 5])
df .^ 2
coalesce.(df, 0)
df .+ [10, 11, 12]

# Code for checking the order of :id column in a data frame

classes_df.id == axes(classes_df, 1)

# Code for the difference between ! and : in broadcasting assignment

df = DataFrame(a=1:3, b=1:3)
df[!, :a] .= "x"
df[:, :b] .= "x"
df

# Code for the difference between ! and : in assignment

df = DataFrame(a=1:3, b=1:3, c=1:3)
df[!, :a] = ["x", "y", "z"]
df[:, :b] = ["x", "y", "z"]
df[:, :c] = [11, 12, 13]
df

# Codes for section 12.2

# Code for listing 12.4

using Graphs
gh = SimpleGraph(nrow(classes_df))
for (src, dst) in eachrow(edges_df)
    add_edge!(gh, src, dst)
end
gh
ne(gh)
nv(gh)

# Code for iterator destruction in iteration specification

mat = [1 2; 3 4; 5 6]
for (x1, x2) in eachrow(mat)
    @show x1, x2
end

# Code for getting degrees of nodes in the graph

degree(gh)

# Code for adding a column to a data frame

classes_df.deg = degree(gh)

# Code for the difference between ! and : when adding a column

df = DataFrame()
x = [1, 2, 3]
df[!, :x1] = x
df[:, :x2] = x
df
df.x1 === x
df.x2 === x
df.x2 == x

# Code for creating a column using broadcasting

df.x3 .= 1
df

# Code for edge iterator of a graph

edges(gh)

e1 = first(edges(gh))
dump(e1)
e1.src
e1.dst

# Code for listing 12.5

function deg_class(gh, class)
    deg_ml = zeros(Int, length(class))
    deg_web = zeros(Int, length(class))
    for edge in edges(gh)
        a, b = edge.src, edge.dst
        if class[b] == 1
            deg_ml[a] += 1
        else
            deg_web[a] += 1
        end
        if class[a] == 1
            deg_ml[b] += 1
        else
            deg_web[b] += 1
        end
    end
    return (deg_ml, deg_web)
end

# Code for computing machine learning and web neighbors for gh graph

classes_df.deg_ml, classes_df.deg_web =
deg_class(gh, classes_df.ml_target)

# Code for checking type stability of deg_class function

@time deg_class(gh, classes_df.ml_target);
@code_warntype deg_class(gh, classes_df.ml_target)

# Code for checking the classes_df summary statistics

describe(classes_df, :min, :max, :mean, :std)

# Code for average degree of node in the graph

2 * ne(gh) / nv(gh)

# Code for checking correctness of computations

classes_df.deg_ml + classes_df.deg_web == classes_df.deg

# Code for showing that DataFrames.jl checks consistency of stored objects

df = DataFrame(a=1, b=11)
push!(df.a, 2)
df

# Codes for section 12.3

# Code for computing groupwise means of columns

using Statistics
for type in [0, 1], col in ["deg_ml", "deg_web"]
    println((type, col, mean(classes_df[classes_df.ml_target .== type, col])))
end

gdf = groupby(classes_df, :ml_target)

combine(gdf,
        :deg_ml => mean => :mean_deg_ml,
        :deg_web => mean => :mean_deg_web)

using DataFramesMeta
@combine(gdf,
         :mean_deg_ml = mean(:deg_ml),
         :mean_deg_web = mean(:deg_web))

# Code for simple plotting of relationship between developer degree and type

using Plots
scatter(classes_df.deg_ml, classes_df.deg_web;
        color=[x == 1 ? "black" : "gray" for x in classes_df.ml_target],
        xlabel="degree ml", ylabel="degree web", labels=false)

# Code for aggregation of degree data

agg_df = combine(groupby(classes_df, [:deg_ml, :deg_web]),
                 :ml_target => (x -> 1 - mean(x)) => :web_mean)

# Code for comparison how Julia parses expressions

:ml_target => (x -> 1 - mean(x)) => :web_mean
:ml_target => x -> 1 - mean(x) => :web_mean

# Code for aggregation using DataFramesMeta.jl

@combine(groupby(classes_df, [:deg_ml, :deg_web]),
         :web_mean = 1 - mean(:ml_target))

# Code for getting summary information about the aggregated data frame

describe(agg_df)

# Code for log1p function

log1p(0)

# Code for listing 12.6

function gen_ticks(maxv)
    max2 = round(Int, log2(maxv))
    tick = [0; 2 .^ (0:max2)]
    return (log1p.(tick), tick)
end

log1pjitter(x) = log1p(x) - 0.05 + rand() / 10

using Random
Random.seed!(1234);
scatter(log1pjitter.(agg_df.deg_ml),
        log1pjitter.(agg_df.deg_web);
        zcolor=agg_df.web_mean,
        xlabel="degree ml", ylabel="degree web",
        markersize=2, markerstrokewidth=0.5, markeralpha=0.8,
        legend=:topleft, labels="fraction web",
        xticks=gen_ticks(maximum(classes_df.deg_ml)),
        yticks=gen_ticks(maximum(classes_df.deg_web)))

# Code for fitting logistic regression model

using GLM
glm(@formula(ml_target~log1p(deg_ml)+log1p(deg_web)), classes_df, Binomial(), LogitLink())

# Code for inspecting @formula result

@formula(ml_target~log1p(deg_ml)+log1p(deg_web))

# Code for inserting columns to a data frame

df = DataFrame(x=1:2)
insertcols!(df, :y => 4:5)
insertcols!(df, :y => 4:5)
insertcols!(df, :z => 1)

insertcols!(df, 1, :a => 0)
insertcols!(df, :x, :pre_x => 2)
insertcols!(df, :x, :post_x => 3, after=true)
