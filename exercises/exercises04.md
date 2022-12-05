# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 4

# Problems

### Exercise 1

Create a matrix of shape 2x3 containing numbers from 1 to 6 (fill the matrix
columnwise with consecutive numbers). Next calculate sum, mean and standard
deviation of each row and each column of this matrix.

<details>
<summary>Solution</summary>

Write:
```
julia> using Statistics

julia> mat = [1 3 5
              2 4 6]
2×3 Matrix{Int64}:
 1  3  5
 2  4  6

julia> sum(mat, dims=1)
1×3 Matrix{Int64}:
 3  7  11

julia> sum(mat, dims=2)
2×1 Matrix{Int64}:
  9
 12

julia> mean(mat, dims=1)
1×3 Matrix{Float64}:
 1.5  3.5  5.5

julia> mean(mat, dims=2)
2×1 Matrix{Float64}:
 3.0
 4.0

julia> std(mat, dims=1)
1×3 Matrix{Float64}:
 0.707107  0.707107  0.707107

julia> std(mat, dims=2)
2×1 Matrix{Float64}:
 2.0
 2.0
```

Observe that the returned statistics are also stored in matrices.
If we compute them for columns (`dims=1`) then the produced matrix has one row.
If we compute them for rows (`dims=2`) then the produced matrix has one column.

</details>

### Exercise 2

For each column of the matrix created in exercise 1 compute its range
(i.e. the difference between maximum and minimum element stored in it).

<details>
<summary>Solution</summary>

Here are some ways you can do it:
```
julia> [maximum(x) - minimum(x) for x in eachcol(mat)]
3-element Vector{Int64}:
 1
 1
 1

julia> map(x -> maximum(x) - minimum(x), eachcol(mat))
3-element Vector{Int64}:
 1
 1
 1
```

Observe that if we used `eachcol` the produced result is a vector (not a matrix
like in exercise 1).

</details>

### Exercise 3

This is data for car speed (mph) and distance taken to stop (ft)
from Ezekiel, M. (1930) Methods of Correlation Analysis. Wiley.

```
speed  dist
    4     2
    4    10
    7     4
    7    22
    8    16
    9    10
   10    18
   10    26
   10    34
   11    17
   11    28
   12    14
   12    20
   12    24
   12    28
   13    26
   13    34
   13    34
   13    46
   14    26
   14    36
   14    60
   14    80
   15    20
   15    26
   15    54
   16    32
   16    40
   17    32
   17    40
   17    50
   18    42
   18    56
   18    76
   18    84
   19    36
   19    46
   19    68
   20    32
   20    48
   20    52
   20    56
   20    64
   22    66
   23    54
   24    70
   24    92
   24    93
   24   120
   25    85
```

Load this data into Julia (this is part of the exercise) and fit a linear
regression where speed is a feature and distance is target variable.

<details>
<summary>Solution</summary>

First create a matrix with source data by copy pasting it from the exercise
like this:
```
data = [
    4     2
    4    10
    7     4
    7    22
    8    16
    9    10
   10    18
   10    26
   10    34
   11    17
   11    28
   12    14
   12    20
   12    24
   12    28
   13    26
   13    34
   13    34
   13    46
   14    26
   14    36
   14    60
   14    80
   15    20
   15    26
   15    54
   16    32
   16    40
   17    32
   17    40
   17    50
   18    42
   18    56
   18    76
   18    84
   19    36
   19    46
   19    68
   20    32
   20    48
   20    52
   20    56
   20    64
   22    66
   23    54
   24    70
   24    92
   24    93
   24   120
   25    85
]
```

Now use the GLM.jl package to fit the model:

```
julia> using GLM

julia> lm(@formula(distance~speed), (distance=data[:, 2], speed=data[:, 1]))
StatsModels.TableRegressionModel{LinearModel{GLM.LmResp{Vector{Float64}}, GLM.DensePredChol{Float64, LinearAlgebra.CholeskyPivoted{Float64, Matrix{Float64}, Vector{Int64, Matrix{Float64}}

distance ~ 1 + speed

Coefficients:
─────────────────────────────────────────────────────────────────────────
                 Coef.  Std. Error      t  Pr(>|t|)  Lower 95%  Upper 95%
─────────────────────────────────────────────────────────────────────────
(Intercept)  -17.5791     6.75844   -2.60    0.0123  -31.1678    -3.99034
speed          3.93241    0.415513   9.46    <1e-11    3.09696    4.76785
─────────────────────────────────────────────────────────────────────────
```

You can get the same estimates using the `\` operator like this:
```
julia> [ones(50) data[:, 1]] \ data[:, 2]
2-element Vector{Float64}:
 -17.579094890510966
   3.9324087591240877
```

</details>

### Exercise 4

Plot the data loaded in exercise 4. Additionally plot the fitted regression
(you need to check Plots.jl documentation to find a way to do this).

<details>
<summary>Solution</summary>

Run the following:
```
using Plots
scatter(data[:, 1], data[:, 2];
        xlab="speed", ylab="distance", legend=false, smooth=true)
```

The `smooth=true` keyword argument adds the linear regression line to the plot.

</details>

### Exercise 5

A simple code for calculation of Fibonacci numbers for positive
arguments is as follows:

```
fib(n) =n < 3 ? 1 : fib(n-1) + fib(n-2)
```

Using the BenchmarkTools.jl package measure runtime of this function for
`n` ranging from `1` to `20`.

<details>
<summary>Solution</summary>

Use the following code:
```
julia> using BenchmarkTools

julia> for i in 1:40
           print(i, " ")
           @btime fib($i)
       end
1   2.500 ns (0 allocations: 0 bytes)
2   2.700 ns (0 allocations: 0 bytes)
3   4.800 ns (0 allocations: 0 bytes)
4   7.500 ns (0 allocations: 0 bytes)
5   12.112 ns (0 allocations: 0 bytes)
6   19.980 ns (0 allocations: 0 bytes)
7   32.125 ns (0 allocations: 0 bytes)
8   52.696 ns (0 allocations: 0 bytes)
9   85.010 ns (0 allocations: 0 bytes)
10   140.311 ns (0 allocations: 0 bytes)
11   222.177 ns (0 allocations: 0 bytes)
12   359.903 ns (0 allocations: 0 bytes)
13   582.123 ns (0 allocations: 0 bytes)
14   1.000 μs (0 allocations: 0 bytes)
15   1.560 μs (0 allocations: 0 bytes)
16   2.522 μs (0 allocations: 0 bytes)
17   4.000 μs (0 allocations: 0 bytes)
18   6.600 μs (0 allocations: 0 bytes)
19   11.400 μs (0 allocations: 0 bytes)
20   18.100 μs (0 allocations: 0 bytes)
```

Notice that execution time for number `n` is roughly sum of execution times
for numbers `n-1` and `n-2`.

</details>

### Exercise 6

Improve the speed of code from exercise 5 by using a dictionary where you
store a mapping of `n` to `fib(n)`. Measure the performance of this function
for the same range of values as in exercise 5.

<details>
<summary>Solution</summary>

Use the following code:

```
julia> fib_dict = Dict{Int, Int}()
Dict{Int64, Int64}()

julia> function fib2(n)
           haskey(fib_dict, n) && return fib_dict[n]
           fib_n = n < 3 ? 1 : fib2(n-1) + fib2(n-2)
           fib_dict[n] = fib_n
           return fib_n
       end
fib2 (generic function with 1 method)

julia> for i in 1:20
           print(i, " ")
           @btime fib2($i)
       end
1   40.808 ns (0 allocations: 0 bytes)
2   40.101 ns (0 allocations: 0 bytes)
3   40.101 ns (0 allocations: 0 bytes)
4   40.707 ns (0 allocations: 0 bytes)
5   42.727 ns (0 allocations: 0 bytes)
6   40.909 ns (0 allocations: 0 bytes)
7   40.404 ns (0 allocations: 0 bytes)
8   40.707 ns (0 allocations: 0 bytes)
9   40.808 ns (0 allocations: 0 bytes)
10   39.798 ns (0 allocations: 0 bytes)
11   40.909 ns (0 allocations: 0 bytes)
12   40.404 ns (0 allocations: 0 bytes)
13   42.872 ns (0 allocations: 0 bytes)
14   42.626 ns (0 allocations: 0 bytes)
15   47.972 ns (1 allocation: 16 bytes)
16   46.505 ns (1 allocation: 16 bytes)
17   46.302 ns (1 allocation: 16 bytes)
18   45.390 ns (1 allocation: 16 bytes)
19   47.160 ns (1 allocation: 16 bytes)
20   46.201 ns (1 allocation: 16 bytes)
```

Note that benchmarking essentially gives us a time of dictionary lookup.
The reason is that `@btime` executes the same expression many times, so
for the fastest execution time the value for each `n` is already stored in
`fib_dict`.

It would be more interesting to see the runtime of `fib2` for some large value
of `n` executed once:

```
julia> @time fib2(100)
  0.000018 seconds (107 allocations: 1.672 KiB)
3736710778780434371

julia> @time fib2(200)
  0.000025 seconds (204 allocations: 20.453 KiB)
-1123705814761610347
```

As you can see things are indeed fast. Note that for `n=200` we get a negative
values because of integer overflow.

As a more advanced topic (not covered in the book) it is worth to comment that
`fib2` is not type stable. If we wanted to make it type stable we need to
declare `fib_dict` dictionary as `const`. Here is the code and benchmarks
(you need to restart Julia to run this test):

```
julia> const fib_dict = Dict{Int, Int}()
Dict{Int64, Int64}()

julia> function fib2(n)
           haskey(fib_dict, n) && return fib_dict[n]
           fib_n = n < 3 ? 1 : fib2(n-1) + fib2(n-2)
           fib_dict[n] = fib_n
           return fib_n
       end
fib2 (generic function with 1 method)

julia> @time fib2(100)
  0.000014 seconds (6 allocations: 5.828 KiB)
3736710778780434371

julia> @time fib2(200)
  0.000011 seconds (3 allocations: 17.312 KiB)
-1123705814761610347
```

As you can see the code does less allocations and is faster now.

</details>

### Exercise 7

Create a vector containing named tuples representing elements of a 4x4 grid.
So the first element of this vector should be `(x=1, y=1)` and last should be
`(x=4, y=4)`. Store the vector in variable `v`.

<details>
<summary>Solution</summary>

Since we are asked to create a vector we can write:

```
julia> v = [(x=x, y=y) for x in 1:4 for y in 1:4]
16-element Vector{NamedTuple{(:x, :y), Tuple{Int64, Int64}}}:
 (x = 1, y = 1)
 (x = 1, y = 2)
 (x = 1, y = 3)
 (x = 1, y = 4)
 (x = 2, y = 1)
 (x = 2, y = 2)
 (x = 2, y = 3)
 (x = 2, y = 4)
 (x = 3, y = 1)
 (x = 3, y = 2)
 (x = 3, y = 3)
 (x = 3, y = 4)
 (x = 4, y = 1)
 (x = 4, y = 2)
 (x = 4, y = 3)
 (x = 4, y = 4)
```

Note (not covered in the book) that you could create a matrix by changing
the syntax a bit:

```
julia> [(x=x, y=y) for x in 1:4, y in 1:4]
4×4 Matrix{NamedTuple{(:x, :y), Tuple{Int64, Int64}}}:
 (x = 1, y = 1)  (x = 1, y = 2)  (x = 1, y = 3)  (x = 1, y = 4)
 (x = 2, y = 1)  (x = 2, y = 2)  (x = 2, y = 3)  (x = 2, y = 4)
 (x = 3, y = 1)  (x = 3, y = 2)  (x = 3, y = 3)  (x = 3, y = 4)
 (x = 4, y = 1)  (x = 4, y = 2)  (x = 4, y = 3)  (x = 4, y = 4)
```

Finally, we can use a bit shorter syntax (covered in chapter 14 of the book):

```
julia> [(; x, y) for x in 1:4, y in 1:4]
4×4 Matrix{NamedTuple{(:x, :y), Tuple{Int64, Int64}}}:
 (x = 1, y = 1)  (x = 1, y = 2)  (x = 1, y = 3)  (x = 1, y = 4)
 (x = 2, y = 1)  (x = 2, y = 2)  (x = 2, y = 3)  (x = 2, y = 4)
 (x = 3, y = 1)  (x = 3, y = 2)  (x = 3, y = 3)  (x = 3, y = 4)
 (x = 4, y = 1)  (x = 4, y = 2)  (x = 4, y = 3)  (x = 4, y = 4)
```

</details>

### Exercise 8

The `filter` function allows you to select some values of an input collection.
Check its documentation first. Next, use it to keep from the vector `v` from
exercise 7 only elements whose sum is even.

<details>
<summary>Solution</summary>

To get help on the `filter` function write `?filter`. Next run:

```
julia> filter(e -> iseven(e.x + e.y), v)
8-element Vector{NamedTuple{(:x, :y), Tuple{Int64, Int64}}}:
 (x = 1, y = 1)
 (x = 1, y = 3)
 (x = 2, y = 2)
 (x = 2, y = 4)
 (x = 3, y = 1)
 (x = 3, y = 3)
 (x = 4, y = 2)
 (x = 4, y = 4)
```

</details>

### Exercise 9

Check the documentation of the `filter!` function. Perform the same operation
as asked in exercise 8 but using `filter!`. What is the difference?

<details>
<summary>Solution</summary>

To get help on the `filter!` function write `?filter!`. Next run:

```
julia> filter!(e -> iseven(e.x + e.y), v)
8-element Vector{NamedTuple{(:x, :y), Tuple{Int64, Int64}}}:
 (x = 1, y = 1)
 (x = 1, y = 3)
 (x = 2, y = 2)
 (x = 2, y = 4)
 (x = 3, y = 1)
 (x = 3, y = 3)
 (x = 4, y = 2)
 (x = 4, y = 4)

julia> v
8-element Vector{NamedTuple{(:x, :y), Tuple{Int64, Int64}}}:
 (x = 1, y = 1)
 (x = 1, y = 3)
 (x = 2, y = 2)
 (x = 2, y = 4)
 (x = 3, y = 1)
 (x = 3, y = 3)
 (x = 4, y = 2)
 (x = 4, y = 4)
```

Notice that `filter` allocated a new vector, while `filter!` updated the `v`
vector in place.

</details>

### Exercise 10

Write a function that takes a number `n`. Next it generates two independent
random vectors of length `n` and returns their correlation coefficient.
Run this function `10000` times for `n` equal to `10`, `100`, `1000`,
and `10000`.
Create a plot with four histograms of distribution of computed Pearson
correlation coefficient. Check in the Plots.jl package which function can be
used to plot histograms.

<details>
<summary>Solution</summary>

You can use for example the following code:

```
using Statistics
using Plots
rand_cor(n) = cor(rand(n), rand(n))
plot([histogram([rand_cor(n) for i in 1:10000], title="n=$n", legend=false)
      for n in [10, 100, 1000, 10000]]...)
```

Observe that as you increase `n` the dispersion of the correlation coefficient
decreases.

</details>
