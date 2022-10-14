# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 10

# Problems

### Exercise 1

Generate a random matrix `mat` having size 5x4 and all elements drawn
independently and uniformly from the [0,1[ interval.
Create a data frame using data from this matrix using auto-generated
column names.

<details>
<summary>Solution</summary>

```
julia> using DataFrames

julia> mat = rand(5, 4)
5×4 Matrix{Float64}:
 0.8386    0.83612   0.0353994  0.15547
 0.590172  0.611815  0.0691152  0.915788
 0.879395  0.07271   0.980079   0.655158
 0.340435  0.756196  0.0697535  0.388578
 0.714515  0.861872  0.971521   0.176768

julia> DataFrame(mat, :auto)
5×4 DataFrame
 Row │ x1        x2        x3         x4
     │ Float64   Float64   Float64    Float64
─────┼─────────────────────────────────────────
   1 │ 0.8386    0.83612   0.0353994  0.15547
   2 │ 0.590172  0.611815  0.0691152  0.915788
   3 │ 0.879395  0.07271   0.980079   0.655158
   4 │ 0.340435  0.756196  0.0697535  0.388578
   5 │ 0.714515  0.861872  0.971521   0.176768
```

</details>

### Exercise 2

Now, using matrix `mat` create a data frame with randomly generated
column names. Use the `randstring` function from the `Random` module
to generate them. Store this data frame in `df` variable.

<details>
<summary>Solution</summary>

```
julia> using Random

julia> df = DataFrame(mat, [randstring() for _ in 1:4])
5×4 DataFrame
 Row │ 6mTK5evn  K8Inf7ER  5Caz55k0   SRiGemsa
     │ Float64   Float64   Float64    Float64
─────┼─────────────────────────────────────────
   1 │ 0.8386    0.83612   0.0353994  0.15547
   2 │ 0.590172  0.611815  0.0691152  0.915788
   3 │ 0.879395  0.07271   0.980079   0.655158
   4 │ 0.340435  0.756196  0.0697535  0.388578
   5 │ 0.714515  0.861872  0.971521   0.176768
```

</details>

### Exercise 3

Create a new data frame, taking `df` as a source that will have the same
columns but its column names will be `y1`, `y2`, `y3`, `y4`.

<details>
<summary>Solution</summary>

```
julia> DataFrame(["y$i" => df[!, i] for i in 1:4])
5×4 DataFrame
 Row │ y1        y2        y3         y4
     │ Float64   Float64   Float64    Float64
─────┼─────────────────────────────────────────
   1 │ 0.8386    0.83612   0.0353994  0.15547
   2 │ 0.590172  0.611815  0.0691152  0.915788
   3 │ 0.879395  0.07271   0.980079   0.655158
   4 │ 0.340435  0.756196  0.0697535  0.388578
   5 │ 0.714515  0.861872  0.971521   0.176768
```

You could also use the `raname` function:
```
julia> rename(df, string.("y", 1:4))
5×4 DataFrame
 Row │ y1        y2        y3         y4
     │ Float64   Float64   Float64    Float64
─────┼─────────────────────────────────────────
   1 │ 0.8386    0.83612   0.0353994  0.15547
   2 │ 0.590172  0.611815  0.0691152  0.915788
   3 │ 0.879395  0.07271   0.980079   0.655158
   4 │ 0.340435  0.756196  0.0697535  0.388578
   5 │ 0.714515  0.861872  0.971521   0.176768
```

</details>

### Exercise 4

Create a dictionary holding `column_name => column_vector` pairs
using data stored in data frame `df`. Save this dictionary in variable `d`.

<details>
<summary>Solution</summary>

```
julia> d = Dict([n => df[:, n] for n in names(df)])
Dict{String, Vector{Float64}} with 4 entries:
  "6mTK5evn" => [0.8386, 0.590172, 0.879395, 0.340435, 0.714515]
  "5Caz55k0" => [0.0353994, 0.0691152, 0.980079, 0.0697535, 0.971521]
  "K8Inf7ER" => [0.83612, 0.611815, 0.07271, 0.756196, 0.861872]
  "SRiGemsa" => [0.15547, 0.915788, 0.655158, 0.388578, 0.176768]
```

or (using the `pairs` function; note that this time column names are `Symbol`):

```
julia> Dict(pairs(eachcol(df)))
Dict{Symbol, AbstractVector} with 4 entries:
  Symbol("6mTK5evn") => [0.8386, 0.590172, 0.879395, 0.340435, 0.714515]
  :SRiGemsa          => [0.15547, 0.915788, 0.655158, 0.388578, 0.176768]
  :K8Inf7ER          => [0.83612, 0.611815, 0.07271, 0.756196, 0.861872]
  Symbol("5Caz55k0") => [0.0353994, 0.0691152, 0.980079, 0.0697535, 0.971521]
```

</details>

### Exercise 5

Create a data frame back from dictionary `d` from exercise 4. Compare it
with `df`.

<details>
<summary>Solution</summary>

```
julia> DataFrame(d)
5×4 DataFrame
 Row │ 5Caz55k0   6mTK5evn  K8Inf7ER  SRiGemsa
     │ Float64    Float64   Float64   Float64
─────┼─────────────────────────────────────────
   1 │ 0.0353994  0.8386    0.83612   0.15547
   2 │ 0.0691152  0.590172  0.611815  0.915788
   3 │ 0.980079   0.879395  0.07271   0.655158
   4 │ 0.0697535  0.340435  0.756196  0.388578
   5 │ 0.971521   0.714515  0.861872  0.176768
```

Note that columns of a data frame are now sorted by their names.
This is done for `Dict` objects because such dictionaries do not have
a defined order of keys.

</details>

### Exercise 6

For data frame `df` compute the dot product between all pairs of its columns.
Use the `dot` function from the `LinearAlgebra` module.

<details>
<summary>Solution</summary>

```
julia> using LinearAlgebra

julia> using StatsBase

julia> pairwise(dot, eachcol(df))
4×4 Matrix{Float64}:
 2.45132  1.99944  1.65026   1.50558
 1.99944  2.39336  1.03322   1.18411
 1.65026  1.03322  1.9153    0.909744
 1.50558  1.18411  0.909744  1.47431
```

</details>

### Exercise 7

Given two data frames:

```
julia> df1 = DataFrame(a=1:2, b=11:12)
2×2 DataFrame
 Row │ a      b
     │ Int64  Int64
─────┼──────────────
   1 │     1     11
   2 │     2     12

julia> df2 = DataFrame(a=1:2, c=101:102)
2×2 DataFrame
 Row │ a      c
     │ Int64  Int64
─────┼──────────────
   1 │     1    101
   2 │     2    102
```

vertically concatenate them so that only columns that are present in both
data frames are kept. Check the documentation of `vcat` to see how to
do it.

<details>
<summary>Solution</summary>

```
julia> vcat(df1, df2, cols=:intersect)
4×1 DataFrame
 Row │ a
     │ Int64
─────┼───────
   1 │     1
   2 │     2
   3 │     1
   4 │     2
```

By default you will get an error:

```
julia> vcat(df1, df2)
ERROR: ArgumentError: column(s) c are missing from argument(s) 1, and column(s) b are missing from argument(s) 2
```

</details>

### Exercise 8

Now append to `df1` table `df2`, but add only the columns from `df2` that
are present in `df1`. Check the documentation of `append!` to see how to
do it.

<details>
<summary>Solution</summary>

```
julia> append!(df1, df2, cols=:subset)
4×2 DataFrame
 Row │ a      b
     │ Int64  Int64?
─────┼────────────────
   1 │     1       11
   2 │     2       12
   3 │     1  missing
   4 │     2  missing
```

</details>

### Exercise 9

Create a `circle` data frame, using the `push!` function that will store
1000 samples of the following process:
* draw `x` and `y` uniformly and independently from the [-1,1[ interval;
* compute a binary variable `inside` that is `true` if `x^2+y^2 < 1`
  and is `false` otherwise.

Compute summary statistics of this data frame.

<details>
<summary>Solution</summary>

```
circle=DataFrame()
for _ in 1:1000
    x, y = 2rand()-1, 2rand()-1
    inside = x^2 + y^2 < 1
    push!(circle, (x=x, y=y, inside=inside))
end
describe(circle)
```

We note that mean of variable `inside` is approximately π.

</details>

### Exercise 10

Create a scatterplot of `circle` data frame where its `x` and `y` axis
will be the plotted points and `inside` variable will determine the color
of the plotted point.

<details>
<summary>Solution</summary>

```
using Plots
scatter(circle.x, circle.y, color=[i ? "black" : "red" for i in circle.inside], xlabel="x", ylabel="y", legend=false, size=(400, 400))
scatter(circle.x, circle.y, color=[i ? "black" : "red" for i in circle.inside], xlabel="x", ylabel="y", legend=false, aspect_ratio=:equal)
```

In the solution two ways to plot ensuring the ratio between x and y axis is 1
are shown. Note the differences in the produced output between the two methods.

</details>
