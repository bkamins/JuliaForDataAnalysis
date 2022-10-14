# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 8

# Problems

### Exercise 1

Read data stored in a gzip-compressed file `example8.csv.gz` into a `DataFrame`
called `df`.

<details>
<summary>Solution</summary>

CSV.jl supports reading gzip-compressed files so you can just do:

```
julia> using CSV

julia> using DataFrames

julia> df = CSV.read("example8.csv.gz", DataFrame)
4×2 DataFrame
 Row │ number  square
     │ Int64   Int64
─────┼────────────────
   1 │      1       2
   2 │      2       4
   3 │      3       9
   4 │      4      16
```

You can also do it manually:
```
julia> using CodecZlib # you might need to install this package

julia> compressed = read("example8.csv.gz");

julia> plain = transcode(GzipDecompressor, compressed);

julia> df = CSV.read(plain, DataFrame)
4×2 DataFrame
 Row │ number  square
     │ Int64   Int64
─────┼────────────────
   1 │      1       2
   2 │      2       4
   3 │      3       9
   4 │      4      16
```

</details>

### Exercise 2

Get number of rows, columns, column names and summary statistics of the
`df` data frame from exercise 1.

<details>
<summary>Solution</summary>

```
julia> nrow(df)
4

julia> ncol(df)
2

julia> names(df)
2-element Vector{String}:
 "number"
 "square"

julia> describe(df)
2×7 DataFrame
 Row │ variable  mean     min    median   max    nmissing  eltype
     │ Symbol    Float64  Int64  Float64  Int64  Int64     DataType
─────┼──────────────────────────────────────────────────────────────
   1 │ number       2.5       1      2.5      4         0  Int64
   2 │ square       7.75      2      6.5     16         0  Int64
```

</details>

### Exercise 3

Make a plot of `number` against `square` columns of `df` data frame.

<details>
<summary>Solution</summary>

```
using Plots
plot(df.number, df.square, xlabel="number", ylabel="square", legend=false)
```

</details>

### Exercise 4

Add a column to `df` data frame with name `name string` containing string
representation of numbers in column `number`, i.e.
`["one", "two", "three", "four"]`.

<details>
<summary>Solution</summary>

```
julia> df."name string" = ["one", "two", "three", "four"]
4-element Vector{String}:
 "one"
 "two"
 "three"
 "four"

julia> df
4×3 DataFrame
 Row │ number  square  name string
     │ Int64   Int64   String
─────┼─────────────────────────────
   1 │      1       2  one
   2 │      2       4  two
   3 │      3       9  three
   4 │      4      16  four
```

Note that we needed to use a string as we have space in column name.

</details>

### Exercise 5

Check if `df` contains column `square2`.

<details>
<summary>Solution</summary>

You can use either `hasproperty` or `columnindex`:

```
julia> hasproperty(df, :square2)
false

julia> columnindex(df, :square2)
0
```

Note that if you try to access this column you will get a hint what was the
mistake you most likely made:

```
julia> df.square2
ERROR: ArgumentError: column name :square2 not found in the data frame; existing most similar names are: :square
```

</details>

### Exercise 6

Extract column `number` from `df` and empty it (recall `empty!` function
discussed in chapter 4).

<details>
<summary>Solution</summary>

```
julia> empty!(df[:, :number])
Int64[]
```

Note that you must not do `empty!(df[!, :number])` nor `empty!(df.number)`
as it would corrupt the `df` data frame (these operations do non-copying
extraction of a column from a data frame as opposed to `df[:, :number]`
which makes a copy).

</details>

### Exercise 7

In `Random` module the `randexp` function is defined that samples numbers
from exponential distribution with scale 1.
Draw two 100,000 element samples from this distribution store them
in `x` and `y` vectors. Plot histograms of maximum of pairs of sampled values
and sum of vector `x` and half of vector `y`.

<details>
<summary>Solution</summary>

```
using Random
using Plots
x = randexp(100_000);
y = randexp(100_000);
histogram(x + y / 2, label="mean")
histogram!(max.(x, y), label="maximum")
```

I have put both histograms on the same plot to show that they overlap.

</details>

### Exercise 8

Using vectors `x` and `y` from exercise 7 create the `df` data frame storing them,
and maximum of pairs of sampled values and sum of vector `x` and half of vector `y`.
Compute all standard descriptive statistics of columns of this data frame.

<details>
<summary>Solution</summary>

You might get slightly different results because we did not set
the seed of random number generator when creating `x` and `y` vectors:

```
julia> df = DataFrame(x=x, y=y);

julia> df."x+y/2" = x + y / 2;

julia> df."max.(x,y)" = max.(x, y);

julia> describe(df, :all)
4×13 DataFrame
 Row │ variable   mean      std       min         q25       median   q75      max      nunique  nmissing  first     last      eltype
     │ Symbol     Float64   Float64   Float64     Float64   Float64  Float64  Float64  Nothing  Int64     Float64   Float64   DataType
─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ x          0.997023  0.999119  3.01389e-6  0.285129  0.68856  1.38414  12.1556                  0  0.250502  0.077737  Float64
   2 │ y          1.00109   0.995904  2.78828e-6  0.289371  0.6957   1.38491  12.0445                  0  0.689659  0.486246  Float64
   3 │ x+y/2      1.49757   1.11676   0.00217486  0.688598  1.2235   2.0113   14.2046                  0  0.595331  0.32086   Float64
   4 │ max.(x,y)  1.49872   1.11295   0.00187844  0.691588  1.22466  2.01257  12.1556                  0  0.689659  0.486246  Float64
```

We indeed see that `x+y/2` and `max.(x,y)` columns have very similar summary
statistics except `first` and `last` as expected.

</details>

### Exercise 9

Store the `df` data frame from exercise 8 in Apache Arrow file and CSV file.
Compare the size of created files using the `filesize` function.

<details>
<summary>Solution</summary>

```
julia> using Arrow

julia> CSV.write("df.csv", df)
"df.csv"

julia> Arrow.write("df.arrow", df)
"df.arrow"

julia> filesize("df.csv")
7587820

julia> filesize("df.arrow")
3200874
```

In this case Apache Arrow file is smaller.

</details>

### Exercise 10

Write the `df` data frame into SQLite database. Next find information about
tables in this database. Run a query against a table representing the `df` data
frame to calculate the mean of column `x`. Does it match the result we got in
exercise 8?

<details>
<summary>Solution</summary>

```
julia> using SQLite

julia> db = SQLite.DB("df.db")
SQLite.DB("df.db")

julia> SQLite.load!(df, db, "df")
"df"

julia> SQLite.tables(db)
1-element Vector{SQLite.DBTable}:
 SQLite.DBTable("df", Tables.Schema:
 :x                   Union{Missing, Float64}
 :y                   Union{Missing, Float64}
 Symbol("x+y/2")      Union{Missing, Float64}
 Symbol("max.(x,y)")  Union{Missing, Float64})

julia> query = DBInterface.execute(db, "SELECT AVG(x) FROM df");

julia> DataFrame(query)
1×1 DataFrame
 Row │ AVG(x)
     │ Float64
─────┼──────────
   1 │ 0.997023

julia> close(db)
```

The computed mean of column `x` is the same as we got in exercise 8.

</details>
