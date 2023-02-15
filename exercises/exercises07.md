# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 7

# Problems

### Exercise 1

Random.org provides a service that returns random numbers. One of the ways
how you can use it is by sending HTTP GET requests. Here is an example request:

> https://www.random.org/integers/?num=10&min=1&max=6&col=1&base=10&format=plain&rnd=new

If you want to understand all the parameters please check their meaning
[here](https://www.random.org/clients/http/).

For us it is enough that this request generates 10 random integers in the range
from 1 to 6. Run this query in Julia and parse the result.

<details>
<summary>Solution</summary>

Example run:

```
julia> using HTTP

julia> response = HTTP.get("https://www.random.org/integers/?\
                            num=10&min=1&max=6&col=1&base=10&format=plain&rnd=new");

julia> parse.(Int, split(String(response.body)))
10-element Vector{Int64}:
 6
 2
 6
 3
 4
 2
 5
 2
 3
 6
```

</details>

### Exercise 2

Write a function that tries to parse a string as an integer.
If it succeeds it should return the integer, otherwise it should return `0`
but print error message.

<details>
<summary>Solution</summary>

Example function:

```
function str2int(s::AbstractString)
    try
        return parse(Int, s)
    catch e
        println(e)
    end
    return 0
end
```

Let us check it:

```
julia> str2int("10")
10

julia> str2int("  -1  ")
-1

julia> str2int("12345678901234567890")
OverflowError("overflow parsing \"12345678901234567890\"")
0

julia> str2int("1.3")
ArgumentError("invalid base 10 digit '.' in \"1.3\"")
0

julia> str2int("a")
ArgumentError("invalid base 10 digit 'a' in \"a\"")
0
```

An alternative solution would use `tryparse` (not covered in the book):

```
function str2int(s::AbstractString)
    v = tryparse(Int, s)
    if isnothing(v)
        println("error while parsing")
        return 0
    end
    return v
end
```
But this time we do not see the cause of the error.

</details>

### Exercise 3

Create a matrix containing truth table for `&&` operation including `missing`.
If some operation errors store `"error"` in the table. As an extra feature (this
is harder so you can skip it) in each cell store both inputs and output to make
reading the table easier.

<details>
<summary>Solution</summary>

```
julia> function apply_and(x, y)
           try
               return "$x && $y = $(x && y)"
           catch e
               return "$x && $y = error"
           end
       end
apply_and (generic function with 2 methods)

julia> apply_and.([true, false, missing], [true false missing])
3×3 Matrix{String}:
 "true && true = true"      "true && false = false"     "true && missing = missing"
 "false && true = false"    "false && false = false"    "false && missing = false"
 "missing && true = error"  "missing && false = error"  "missing && missing = error"
```

</details>

### Exercise 4

Take a vector `v = [1.5, 2.5, missing, 4.5, 5.5, missing]` and replace all
missing values in it by the mean of the non-missing values.

<details>
<summary>Solution</summary>

```
julia> using Statistics

julia> coalesce.(v, mean(skipmissing(v)))
6-element Vector{Float64}:
 1.5
 2.5
 3.5
 4.5
 5.5
 3.5
```

</details>

### Exercise 5

Take a vector `s = ["1.5", "2.5", missing, "4.5", "5.5", missing]` and parse
strings stored in it as `Float64`, while keeping `missing` values unchanged.

<details>
<summary>Solution</summary>

```
julia> using Missings

julia> passmissing(parse).(Float64, s)
6-element Vector{Union{Missing, Float64}}:
 1.5
 2.5
  missing
 4.5
 5.5
  missing
```

</details>

### Exercise 6

Print to the terminal all days in January 2023 that are Mondays.

<details>
<summary>Solution</summary>

Example:

```
julia> using Dates

julia> for day in Date.(2023, 01, 1:31)
           dayofweek(day) == 1 && println(day)
       end
2023-01-02
2023-01-09
2023-01-16
2023-01-23
2023-01-30
```

</details>

### Exercise 7

Compute the dates that are one month later than January 15, 2020, February 15
2020, March 15, 2020, and April 15, 2020. How many days pass during this one
month. Print the results to the screen?

<details>
<summary>Solution</summary>

Example:

```
julia> for day in Date.(2023, 1:4, 15)
           day_next = day + Month(1)
           println("$day + 1 month = $day_next (difference: $(day_next - day))")
       end
2023-01-15 + 1 month = 2023-02-15 (difference: 31 days)
2023-02-15 + 1 month = 2023-03-15 (difference: 28 days)
2023-03-15 + 1 month = 2023-04-15 (difference: 31 days)
2023-04-15 + 1 month = 2023-05-15 (difference: 30 days)
```

</details>

### Exercise 8

Parse the following string as JSON:
```
str = """
[{"x":1,"y":1},
 {"x":2,"y":4},
 {"x":3,"y":9},
 {"x":4,"y":16},
 {"x":5,"y":25}]
"""
```
into a `json` variable.

<details>
<summary>Solution</summary>

```
julia> using JSON3

julia> json = JSON3.read(str)
5-element JSON3.Array{JSON3.Object, Base.CodeUnits{UInt8, String}, Vector{UInt64}}:
 {
   "x": 1,
   "y": 1
}
 {
   "x": 2,
   "y": 4
}
 {
   "x": 3,
   "y": 9
}
 {
   "x": 4,
   "y": 16
}
 {
   "x": 5,
   "y": 25
}
```

</details>

### Exercise 9

Extract from the `json` variable from exercise 8 two vectors `x` and `y`
that correspond to the fields stored in the JSON structure.
Plot `y` as a function of `x`.

<details>
<summary>Solution</summary>

```
using Plots
x = [el.x for el in json]
y = [el.y for el in json]
plot(x, y, xlabel="x", ylabel="y", legend=false)
```

</details>

### Exercise 10

Given a vector `m = [missing, 1, missing, 3, missing, missing, 6, missing]`.
Use linear interpolation for filling missing values. For the extreme values
use nearest available observation (you will need to consult Impute.jl
documentation to find all required functions).

<details>
<summary>Solution</summary>

```
julia> using Impute

julia> Impute.nocb!(Impute.locf!(Impute.interp(m)))
8-element Vector{Union{Missing, Int64}}:
 1
 1
 2
 3
 4
 5
 6
 6
```

Note that we use the `locf!` and `nocb!` functions (with `!`) to perform
operation in place (a new vector was already allocated by `Impute.interp`).

</details>
