# Bogumił Kamiński, 2022

# Codes for chapter 6

# Code for section 6.1

if isfile("puzzles.csv.bz2")
    @info "file already present"
else
    @info "fetching file"
    download("https://database.lichess.org/" *
            "lichess_db_puzzle.csv.bz2",
            "puzzles.csv.bz2")
end

using CodecBzip2
compressed = read("puzzles.csv.bz2")
plain = transcode(Bzip2Decompressor, compressed)

open("puzzles.csv", "w") do io
    println(io, "PuzzleId,FEN,Moves,Rating,RatingDeviation," *
                "Popularity,NbPlays,Themes,GameUrl")
    write(io, plain)
end

readlines("puzzles.csv")

# Code for section 6.2

using CSV
using DataFrames
puzzles = CSV.read("puzzles.csv", DataFrame);

CSV.read(plain, DataFrame);

compressed = nothing
plain = nothing

# Code for listing 6.1

puzzles

# Code for listing 6.2

describe(puzzles)

# Code for getting basic information about a data frame

ncol(puzzles)

nrow(puzzles)

names(puzzles)

# Code for section 6.3

puzzles.Rating

using BenchmarkTools
@benchmark $puzzles.Rating

puzzles.Rating == copy(puzzles.Rating)

puzzles.Rating === copy(puzzles.Rating)

puzzles.Rating === puzzles.Rating

copy(puzzles.Rating) === copy(puzzles.Rating)

puzzles."Rating"

col = "Rating"

data_frame_name[selected_rows, selected_columns]

puzzles[:, "Rating"]
puzzles[:, :Rating]
puzzles[:, 4]
puzzles[:, col]

columnindex(puzzles, "Rating")

columnindex(puzzles, "Some fancy column name")

hasproperty(puzzles, "Rating")
hasproperty(puzzles, "Some fancy column name")

@benchmark $puzzles[:, :Rating]

puzzles[!, "Rating"]
puzzles[!, :Rating]
puzzles[!, 4]
puzzles[!, col]

plot(histogram(puzzles.Rating, label="Rating"),
     histogram(puzzles.RatingDeviation, label="RatingDeviation"),
     histogram(puzzles.Popularity, label="Popularity"),
     histogram(puzzles.NbPlays, label="NbPlays"))

plot([histogram(puzzles[!, col], label=col) for
      col in ["Rating", "RatingDeviation",
              "Popularity", "NbPlays"]]...)

# Code for section 6.4

using Statistics
plays_lo = median(puzzles.NbPlays)
puzzles.NbPlays .> plays_lo

puzzles.NbPlays > plays_lo

rating_lo = 1500
rating_hi = quantile(puzzles.Rating, 0.99)
rating_lo .< puzzles.Rating .< rating_hi

row_selector = (puzzles.NbPlays .> plays_lo) .&&
               (rating_lo .< puzzles.Rating .< rating_hi)

sum(row_selector)
count(row_selector)

# Code for listing 6.3

good = puzzles[row_selector, ["Rating", "Popularity"]]

# Code for plotting histograms

plot(histogram(good.Rating, label="Rating"),
     histogram(good.Popularity, label="Popularity"))

# Code for column selectors

puzzles[1, "Rating"]

puzzles[:, "Rating"]

row1 = puzzles[1, ["Rating", "Popularity"]]

row1["Rating"]
row1[:Rating]
row1[1]
row1.Rating
row1."Rating"

good = puzzles[row_selector, ["Rating", "Popularity"]]

good[1, "Rating"]
good[1, :]
good[:, "Rating"]
good[:, :]

names(puzzles, ["Rating", "Popularity"])
names(puzzles, [:Rating, :Popularity])
names(puzzles, [4, 6])
names(puzzles, [false, false, false, true, false, true, false, false, false])
names(puzzles, r"Rating")
names(puzzles, Not([4, 6]))
names(puzzles, Not(r"Rating"))
names(puzzles, Between("Rating", "Popularity"))
names(puzzles, :)
names(puzzles, All())
names(puzzles, Cols(r"Rating", "NbPlays"))
names(puzzles, Cols(startswith("P")))

names(puzzles, startswith("P"))

names(puzzles, Real)

names(puzzles, AbstractString)

puzzles[:, names(puzzles, Real)]

# Code for row subsetting

df1 = puzzles[:, ["Rating", "Popularity"]];
df2 = puzzles[!, ["Rating", "Popularity"]];

df1 == df2
df1 == puzzles
df2 == puzzles

df1.Rating === puzzles.Rating
df1.Popularity === puzzles.Popularity
df2.Rating === puzzles.Rating
df2.Popularity === puzzles.Popularity

@benchmark $puzzles[:, ["Rating", "Popularity"]]
@benchmark $puzzles[!, ["Rating", "Popularity"]]

puzzles[1, 1]
puzzles[[1], 1]
puzzles[1, [1]]
puzzles[[1], [1]]

# Code for making views

@view puzzles[1, 1]

@view puzzles[[1], 1]

@view puzzles[1, [1]]

@view puzzles[[1], [1]]

@btime $puzzles[$row_selector, ["Rating", "Popularity"]];
@btime @view $puzzles[$row_selector, ["Rating", "Popularity"]];

parentindices(@view puzzles[row_selector, ["Rating", "Popularity"]])

# Code for section 6.5

describe(good)

rating_mapping = Dict{Int, Vector{Int}}()
for (i, rating) in enumerate(good.Rating)
    if haskey(rating_mapping, rating)
        push!(rating_mapping[rating], i)
    else
        rating_mapping[rating] = [i]
    end
end
rating_mapping

good[rating_mapping[2108], :]

unique(good[rating_mapping[2108], :].Rating)

using Statistics
mean(good[rating_mapping[2108], "Popularity"])

ratings = unique(good.Rating)

mean_popularities = map(ratings) do rating
    indices = rating_mapping[rating]
    popularities = good[indices, "Popularity"]
    return mean(popularities)
end

using Plots
scatter(ratings, mean_popularities;
        xlabel="rating", ylabel="mean popularity", legend=false)

import Loess
model = Loess.loess(ratings, mean_popularities);
ratings_predict = float.(sort(ratings))
popularity_predict = Loess.predict(model, ratings_predict)

plot!(ratings_predict, popularity_predict, width=5, color="black")
