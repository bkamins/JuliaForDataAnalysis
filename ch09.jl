# Bogumił Kamiński, 2022

# Codes for chapter 9

# Code for section 9.1

using DataFrames
using CSV
using Plots
puzzles = CSV.read("puzzles.csv", DataFrame);

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

# Code for listing 9.1

good = puzzles[row_selector, ["Rating", "Popularity"]]

# Code for plotting histograms

plot(histogram(good.Rating; label="Rating"),
     histogram(good.Popularity; label="Popularity"))

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

df_small = DataFrame(id=1:4)
df_small[[1, 3], :]
df_small[[true, false, true, false], :]
df_small[Not([2, 4]), :]
df_small[Not([false, true, false, true]), :]

df1 = puzzles[:, ["Rating", "Popularity"]];
df2 = puzzles[!, ["Rating", "Popularity"]];

df1 == df2

df1.Rating === puzzles.Rating
df1.Popularity === puzzles.Popularity
df2.Rating === puzzles.Rating
df2.Popularity === puzzles.Popularity

using BenchmarkTools
@btime $puzzles[:, ["Rating", "Popularity"]];
@btime $puzzles[!, ["Rating", "Popularity"]];

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

# Code for section 9.2

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

scatter(ratings, mean_popularities;
        xlabel="rating", ylabel="mean popularity", legend=false)

using Loess
model = loess(ratings, mean_popularities);
ratings_predict = float(sort(ratings))
popularity_predict = predict(model, ratings_predict)

methods(predict)

plot!(ratings_predict, popularity_predict; width=5, color="black")

combine(groupby(good, :Rating), :Popularity => mean)
