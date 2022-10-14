# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 5

# Problems

### Exercise 1

Create a matrix containing truth table for `&&` and `||` operations.

<details>
<summary>Solution</summary>

You can do it as follows:
```
julia> [true, false] .&& [true false]
2×2 BitMatrix:
 1  0
 0  0

julia> [true, false] .|| [true false]
2×2 BitMatrix:
 1  1
 1  0
```

Note that the first array is a vector, while the second array is a 1-row matrix.

</details>

### Exercise 2

The `issubset` function checks if one collection is a subset of other
collection.

Now take a range `4:6` and check if it is a subset of ranges `4+k:4-k` for
`k` varying from `1` to `3`. Store the result in a vector.

<details>
<summary>Solution</summary>

You can do it like this using broadcasting:
```
julia> issubset.(Ref(4:6), [4-k:4+k for k in 1:3])
3-element BitVector:
 0
 1
 1
```
Note that you need to use `Ref` to protect `4:6` from being broadcasted over.

</details>

### Exercise 3

Write a function that accepts two vectors and returns `true` if they have equal
length and otherwise returns `false`.

<details>
<summary>Solution</summary>

This function can be written as follows:

```
function equallength(x::AbstractVector, y::AbstractVector) = length(x) == length(y)
```

</details>

### Exercise 4

Consider the vectors `x = [1, 2, 1, 2, 1, 2]`,
`y = ["a", "a", "b", "b", "b", "a"]`, and `z = [1, 2, 1, 2, 1, 3]`.
Calculate their Adjusted Mutual Information using scikit-learn.

<details>
<summary>Solution</summary>

You can do this exercise as follows:
```
julia> using PyCall

julia> metrics = pyimport("sklearn.metrics");

julia> metrics.adjusted_mutual_info_score(x, y)
-0.11111111111111087

julia> metrics.adjusted_mutual_info_score(x, z)
0.7276079390930807

julia> metrics.adjusted_mutual_info_score(y, z)
-0.21267989848846763
```

</details>

### Exercise 5

Using Adjusted Mutual Information function from exercise 4 generate
a pair of random vectors of length 100 containing integer numbers from the
range `1:5`. Repeat this exercise 1000 times and plot a histogram of AMI.
Check in the documentation of the `rand` function how you can draw a sample
from a collection of values.

<details>
<summary>Solution</summary>

You can create such a plot using the following commands:

```
using Plots
histogram([metrics.adjusted_mutual_info_score(rand(1:5, 100), rand(1:5, 100))
           for i in 1:1000], label="AMI")
```

You can check that AMI oscillates around 0.

</details>

### Exercise 6

Adjust the code from exercise 5 but replace first 50 elements of each vector
with zero. Repeat the experiment.

<details>
<summary>Solution</summary>

This time it is convenient to write a helper function. Note that we use
broadcasting to update values in the vectors.

```
function exampleAMI()
    x = rand(1:5, 100)
    y = rand(1:5, 100)
    x[1:50] .= 0
    y[1:50] .= 0
    return metrics.adjusted_mutual_info_score(x, y)
end
histogram([exampleAMI() for i in 1:1000], label="AMI")
```

Note that this time AMI is a bit below 0.5, which shows a better match between
vectors.

</details>

### Exercise 7

Write a function that takes a vector of integer values and returns a dictionary
giving information how many times each integer was present in the passed vector.

Test this function on vectors `v1 = [1, 2, 3, 2, 3, 3]`, `v2 = [true, false]`,
and `v3 = 3:5`.

<details>
<summary>Solution</summary>

```
julia> function counter(v::AbstractVector{<:Integer})
           d = Dict{eltype(v), Int}()
           for x in v
               if haskey(d, x)
                   d[x] += 1
               else
                   d[x] = 1
               end
           end
           return d
       end
counter (generic function with 1 method)

julia> counter(v1)
Dict{Int64, Int64} with 3 entries:
  2 => 2
  3 => 3
  1 => 1

julia> counter(v2)
Dict{Bool, Int64} with 2 entries:
  0 => 1
  1 => 1

julia> counter(v3)
Dict{Int64, Int64} with 3 entries:
  5 => 1
  4 => 1
  3 => 1
```

Note that we used the `eltype` function to set a proper key type for
dictionary `d`.

</details>

### Exercise 8

Write code that creates a `Bool` diagonal matrix of size 5x5.

<details>
<summary>Solution</summary>

This is a way to do it:
```
julia> 1:5 .== (1:5)'
5×5 BitMatrix:
 1  0  0  0  0
 0  1  0  0  0
 0  0  1  0  0
 0  0  0  1  0
 0  0  0  0  1
```

Using the `LinearAlgebra` module you could also write:

```
julia> using LinearAlgebra

julia> I(5)
5×5 Diagonal{Bool, Vector{Bool}}:
 1  ⋅  ⋅  ⋅  ⋅
 ⋅  1  ⋅  ⋅  ⋅
 ⋅  ⋅  1  ⋅  ⋅
 ⋅  ⋅  ⋅  1  ⋅
 ⋅  ⋅  ⋅  ⋅  1
```

</details>

### Exercise 9

Write a code comparing performance of calculation of sum of logarithms of
elements of a vector `1:100` using broadcasting and the `sum` function vs only
the `sum` function taking a function as a first argument.

<details>
<summary>Solution</summary>

Here is how you can do it:

```
julia> using BenchmarkTools

julia> @btime sum(log.(1:100))
  1.620 μs (1 allocation: 896 bytes)
363.7393755555635

julia> @btime sum(log, 1:100)
  1.570 μs (0 allocations: 0 bytes)
363.7393755555636
```

As you can see using the `sum` function with `log` as its first argument
is a bit faster as it is not allocating.

</details>

### Exercise 10

Create a dictionary in which for each number from `1` to `10` you will store
a vector of its positive divisors. You can check the reminder of division
of two values using the `rem` function.

Additionally (not covered in the book), you can drop elements
from a comprehension if you add an `if` clause after the `for` clause, for
example to keep only odd numbers from range `1:10` do:

```
julia> [i for i in 1:10 if isodd(i)]
5-element Vector{Int64}:
 1
 3
 5
 7
 9
```

You can populate a dictionary by passing a vector of pairs to it (not covered in
the book), for example:

```
julia> Dict(["a" => 1, "b" => 2])
Dict{String, Int64} with 2 entries:
  "b" => 2
  "a" => 1
```

<details>
<summary>Solution</summary>

Here is how you can do it:

```
julia> Dict([i => [j for j in 1:i if rem(i, j) == 0] for i in 1:10])
Dict{Int64, Vector{Int64}} with 10 entries:
  5  => [1, 5]
  4  => [1, 2, 4]
  6  => [1, 2, 3, 6]
  7  => [1, 7]
  2  => [1, 2]
  10 => [1, 2, 5, 10]
  9  => [1, 3, 9]
  8  => [1, 2, 4, 8]
  3  => [1, 3]
  1  => [1]
```

</details>
