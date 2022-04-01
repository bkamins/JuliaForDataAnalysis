# Bogumił Kamiński, 2022

# Codes for chapter 8

# Code for section 8.1

import Downloads
if isfile("puzzles.csv.bz2")
    @info "file already present"
else
    @info "fetching file"
    Downloads.download("https://database.lichess.org/" *
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

# Code for section 8.2

using CSV
using DataFrames
puzzles = CSV.read("puzzles.csv", DataFrame);

puzzles2 = CSV.read(plain, DataFrame;
                    header=["PuzzleId", "FEN", "Moves",
                            "Rating","RatingDeviation",
                            "Popularity", "NbPlays",
                            "Themes","GameUrl"]);
puzzles == puzzles2

compressed = nothing
plain = nothing

# Code for listing 8.1

puzzles

# Code for listing 8.2

describe(puzzles)

# Code for getting basic information about a data frame

ncol(puzzles)

nrow(puzzles)

names(puzzles)

CSV.write("puzzles2.csv", puzzles)

read("puzzles2.csv")

read("puzzles2.csv") == read("puzzles.csv")

# Code for section 8.3

puzzles.Rating

using BenchmarkTools
@btime $puzzles.Rating;

puzzles.Rating == copy(puzzles.Rating)

puzzles.Rating === copy(puzzles.Rating)

puzzles.Rating === puzzles.Rating

copy(puzzles.Rating) === copy(puzzles.Rating)

puzzles."Rating"

col = "Rating"

# data_frame_name[selected_rows, selected_columns]

puzzles[:, "Rating"]
puzzles[:, :Rating]
puzzles[:, 4]
puzzles[:, col]

columnindex(puzzles, "Rating")

columnindex(puzzles, "Some fancy column name")

hasproperty(puzzles, "Rating")
hasproperty(puzzles, "Some fancy column name")

@btime $puzzles[:, :Rating];

puzzles[!, "Rating"]
puzzles[!, :Rating]
puzzles[!, 4]
puzzles[!, col]

using Plots
plot(histogram(puzzles.Rating, label="Rating"),
     histogram(puzzles.RatingDeviation, label="RatingDeviation"),
     histogram(puzzles.Popularity, label="Popularity"),
     histogram(puzzles.NbPlays, label="NbPlays"))

plot([histogram(puzzles[!, col]; label=col) for
      col in ["Rating", "RatingDeviation",
              "Popularity", "NbPlays"]]...)

# Code for section 8.4

# Codes for Arrow examples
using Arrow
Arrow.write("puzzles.arrow", puzzles)

arrow_table = Arrow.Table("puzzles.arrow")
puzzles_arrow = DataFrame(arrow_table);
puzzles_arrow == puzzles

puzzles_arrow.PuzzleId
puzzles_arrow.PuzzleId[1] = "newID"

puzzles_arrow = copy(puzzles_arrow);
puzzles_arrow.PuzzleId

# Codes for SQLite examples
using SQLite
db = SQLite.DB("puzzles.db")

SQLite.load!(puzzles, db, "puzzles")

SQLite.tables(db)
SQLite.columns(db, "puzzles")

query = DBInterface.execute(db, "SELECT * FROM puzzles")
puzzles_db = DataFrame(query);
puzzles_db == puzzles

puzzles_db.PuzzleId
