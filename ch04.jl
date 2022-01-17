# Bogumił Kamiński, 2022

# Codes for chapter 4

# Code for listing 4.1

import Downloads
Downloads.download("https://raw.githubusercontent.com/" *
                   "sidooms/MovieTweetings/" *
                   "44c525d0c766944910686c60697203cda39305d6/" *
                   "snapshots/10K/movies.dat",
                   "movies.dat")

# Code for string interpolation examples

x = 10
"I have $x apples"

"I have \$100."
"I have $100."

# Code for multiline strings

Downloads.download("https://raw.githubusercontent.com/\
                    sidooms/MovieTweetings/\
                    44c525d0c766944910686c60697203cda39305d6/\
                    snapshots/10K/movies.dat",
                   "movies.dat")

"a\
 b\
 c"

# Code for raw strings

"C:\my_folder\my_file.txt"

raw"C:\my_folder\my_file.txt"

# Code for listing 4.2

movies = readlines("movies.dat")

# Code for section 4.2

movie1 = first(movies)

movie1_parts = split(movie1, "::")

supertype(String)
supertype(SubString{String})

# Code for section 4.3

movie1_parts[2]

rx = r"(.*) \((\d{4})\)$"

m = match(rx, movie1_parts[2])

m[1]
m[2]

parse(Int, m[2])

# Code for listing 4.3

function parseline(line::String)
    parts = split(line, "::")
    m = match(r"(.*) \((\d{4})\)", parts[2])
    return (id=parts[1],
            name=m[1],
            year=parse(Int, m[2]),
            genres=split(parts[3], "|"))
end

# Code for parsing one line of movies data

record1 = parseline(movie1)

# Code for listing 4.4

codeunits("a")
codeunits("ε")
codeunits("∀")

# Codes for different patterns of string subsetting

word = first(record1.name, 8)

record1.name[1:8]

for i in eachindex(word)
    println(i, ": ", word[i])
end

codeunits("ô")

codeunits("Fantômas")

isascii("Hello world!")
isascii("∀ x: x≥0")

word[1]
word[5]

# Code for section 4.5

records = parseline.(movies)

genres = String[]
for record in records
    append!(genres, record.genres)
end
genres

using FreqTables
table = freqtable(genres)
sort!(table)

years = [record.year for record in records]
has_drama = ["Drama" in record.genres for record in records]
drama_prop = proptable(years, has_drama; margins=1)

# Code for listing 4.5

using Plots

plot(names(drama_prop, 1), drama_prop[:, 2]; legend=false,
     xlabel="year", ylabel="Drama probability")

# Code for section 4.6.1

s1 = Symbol("x")
s2 = Symbol("hello world!")
s3 = Symbol("x", 1)

typeof(s1)
typeof(s2)
typeof(s3)

Symbol("1")

:x
:x1

:hello world
:1

# Code for section 4.6.2

supertype(Symbol)

:x == :x
:x == :y

# Code for listing 4.6

using BenchmarkTools
str = string.("x", 1:10^6)
symb = Symbol.(str)
@benchmark "x" in $str
@benchmark :x in $symb

# Code for section 4.7

using InlineStrings
s1 = InlineString("x")
typeof(s1)
s2 = InlineString("∀")
typeof(s2)
sv = inlinestrings(["The", "quick", "brown", "fox", "jumps",
                    "over", "the", "lazy", "dog"])

# Code for listing 4.7

using Random
using BenchmarkTools
Random.seed!(1234);
s1 = [randstring(3) for i in 1:10^6]
s2 = inlinestrings(s1)

# Code for analyzing properties of InlineStrings.jl

Base.summarysize(s1)
Base.summarysize(s2)

@benchmark sort($s1)
@benchmark sort($s2)

# Code for listing 4.8

open("iris.txt", "w") do io
    for i in 1:10^6
        println(io, "Iris setosa")
        println(io, "Iris virginica")
        println(io, "Iris versicolor")
    end
end

# Code for section 4.8.2

uncompressed = readlines("iris.txt")

using PooledArrays
compressed = PooledArray(uncompressed)

Base.summarysize(uncompressed)
Base.summarysize(compressed)

# Code for section 4.8.3

compressed.invpool
compressed.pool

compressed[10]
compressed.pool[compressed.refs[10]]

Base.summarysize.(compressed.pool)

v1 = string.("x", 1:10^6)
v2 = PooledArray(v1)
Base.summarysize(v1)
Base.summarysize(v2)
