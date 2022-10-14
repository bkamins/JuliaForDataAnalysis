# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 3

# Problems

### Exercise 1

Check what methods does the `repeat` function have.
Are they all covered in help for this function?

<details>
<summary>Solution</summary>

Write:
```
julia> methods(repeat)
# 6 methods for generic function "repeat":
[1] repeat(A::AbstractArray; inner, outer) in Base at abstractarraymath.jl:392
[2] repeat(A::AbstractArray, counts...) in Base at abstractarraymath.jl:355
[3] repeat(c::Char, r::Integer) in Base at strings/string.jl:336
[4] repeat(c::AbstractChar, r::Integer) in Base at strings/string.jl:335
[5] repeat(s::Union{SubString{String}, String}, r::Integer) in Base at strings/substring.jl:248
[6] repeat(s::AbstractString, r::Integer) in Base at strings/basic.jl:715
```

Now write `?repeat` and you will see that there are four entries in help.
The reason is that for `Char` and `AbstractChar` as well as for
`AbstractString` and `Union{SubString{String}, String}` there is one help entry.

Why do these cases have two methods defined?
The reason is performance. For example `repeat(c::AbstractChar, r::Integer)`
is a generic function that accept any character values
and `repeat(c::Char, r::Integer)` is its faster version
that accepts values that have `Char` type only (and it is invoked by Julia
if value of type `Char` is passed as an argument to `repeat`).

</details>

### Exercise 2

Write a function `fun2` that takes any vector and returns the difference between
the largest and the smallest element in this vector.

<details>
<summary>Solution</summary>

You can define is as follows:
```
fun2(x::AbstractVector) = maximum(x) - minimum(x)
```
or as follows:
```
function fun2(x::AbstractVector)
    lo, hi = extrema(x)
    return hi - lo
end
```
Note that these two functions will work with vectors of any elements that
are ordered and support subtraction (they do not have to be numbers).

</details>

### Exercise 3

Generate a vector of one million random numbers from `[0, 1]` interval.
Check what is a faster way to get a maximum and minimum element in it. One
option is by using the `maximum` and `minimum` functions and the other is by
using the `extrema` function.

<details>
<summary>Solution</summary>

Here is a way to compare the performance of both options:
```
julia> using BenchmarkTools

julia> x = rand(10^6);

julia> @btime minimum($x), maximum($x)
  860.700 μs (0 allocations: 0 bytes)
(1.489173560242918e-6, 0.9999984347293639)

julia> @btime extrema($x)
  2.185 ms (0 allocations: 0 bytes)
(1.489173560242918e-6, 0.9999984347293639)
```

As you can see in this situation, although `extrema` does the operation
in a single pass over `x` it is slower than computing `minimum` and `maximum`
in two passes.

</details>

### Exercise 4

Assume you have accidentally typed `+x = 1` when wanting to assign `1` to
variable `x`. What effects can this operation have?

<details>
<summary>Solution</summary>

If it is a fresh Julia session you define a new function in `Main` for `+` operator:

```
julia> +x=1
+ (generic function with 1 method)

julia> methods(+)
# 1 method for generic function "+":
[1] +(x) in Main at REPL[1]:1

julia> +(10)
1
```

This will also break any further uses of `+` in your programs:

```
julia> 1 + 2
ERROR: MethodError: no method matching +(::Int64, ::Int64)
You may have intended to import Base.:+
Closest candidates are:
  +(::Any) at REPL[1]:1
```

If you earlier used addition in this Julia session then the operation will error.
Start a fresh Julia session:

```
julia> 1 + 2
3

julia> +x=1
ERROR: error in method definition: function Base.+ must be explicitly imported to be extended
```

</details>

### Exercise 5

What is the result of calling the `subtypes` on `Union{Bool, Missing}` and why?

<details>
<summary>Solution</summary>

You get an empty vector:
```
julia> subtypes(Union{Float64, Missing})
Type[]
```

The reason is that the `subtypes` function returns subtypes of explicitly
declared types that have names (type of such types is `DataType` in Julia).

*Extra* for this reason `subtypes` has a limited use. To check if one type
is a subtype of some other type use the `<:` operator.

</details>

### Exercise 6

Define two identical anonymous functions `x -> x + 1` in global scope? Do they
have the same type?

<details>
<summary>Solution</summary>

No, each of them has a different type:
```
julia> f1 = x -> x + 1
#1 (generic function with 1 method)

julia> f2 = x -> x + 1
#3 (generic function with 1 method)

julia> typeof(f1)
var"#1#2"

julia> typeof(f2)
var"#3#4"
```

This is the reason why function call like `sum(x -> x^2, 1:10)` in global
scope triggers compilation each time:

```
julia> @time sum(x -> x^2, 1:10)
  0.070714 seconds (167.41 k allocations: 8.815 MiB, 14.29% gc time, 93.91% compilation time)
385

julia> @time sum(x -> x^2, 1:10)
  0.020971 seconds (47.82 k allocations: 2.529 MiB, 99.75% compilation time)
385

julia> @time sum(x -> x^2, 1:10)
  0.021184 seconds (47.81 k allocations: 2.529 MiB, 99.77% compilation time)
385
```

</details>

### Exercise 7

Define the `wrap` function taking one argument `i` and returning the anonymous
function `x -> x + i`. Is the type of such anonymous function the same across
calls to `wrap` function?

<details>
<summary>Solution</summary>

Yes, the type is the same:

```
julia> wrap(i) = x -> x + i
wrap (generic function with 1 method)

julia> typeof(wrap(1))
var"#11#12"

julia> typeof(wrap(2))
var"#11#12"
```

Julia defines a new type for such an anonymous function only once
The consequence of this is that e.g. expressions inside a function like
`sum(x -> x ^ i, 1:10)` where `i` is an argument to a function do not trigger
compilation (as opposed to similar expressions in global scope, see exercise 6).

```
julia> sumi(i) = sum(x -> x^i, 1:10)
sumi (generic function with 1 method)

julia> @time sumi(1)
  0.000004 seconds
55

julia> @time sumi(2)
  0.000001 seconds
385

julia> @time sumi(3)
  0.000003 seconds
3025
```

</details>

### Exercise 8

You want to write a function that accepts any `Integer` except `Bool` and returns
the passed value. If `Bool` is passed an error should be thrown.

<details>
<summary>Solution</summary>

We check subtypes of `Integer`:

```
julia> subtypes(Integer)
3-element Vector{Any}:
 Bool
 Signed
 Unsigned
```

The first way to write such a function is then:
```
fun1(i::Union{Signed, Unsigned}) = i
```
and now we have:
```
julia> fun1(1)
1

julia> fun1(true)
ERROR: MethodError: no method matching fun1(::Bool)
```

The second way is:
```
fun2(i::Integer) = i
fun2(::Bool) = throw(ArgumentError("Bool is not supported"))
```

and now you have:
```
julia> fun2(1)
1

julia> fun2(true)
ERROR: ArgumentError: Bool is not supported
```

</details>

### Exercise 9

The `@time` macro measures time taken by an expression run and prints it,
but returns the value of the expression.
The `@elapsed` macro works differently - it does not print anything, but returns
time taken to evaluate an expression. Test the `@elapsed` macro by to see how
long it takes to shuffle a vector of one million floats. Use the `shuffle` function
from `Random` module.

<details>
<summary>Solution</summary>

Here is the code that performs the task:
```
julia> using Random # needed to get access to shuffle

julia> x = rand(10^6); # generate random floats

julia> @elapsed shuffle(x)
0.0518085

julia> @elapsed shuffle(x)
0.01257

julia> @elapsed shuffle(x)
0.012483
```

Note that the first time we run `shuffle` it takes longer due to compilation.

</details>

### Exercise 10

Using the `@btime` macro benchmark the time of calculating the sum of one million
random floats.

<details>
<summary>Solution</summary>

The code you can use is:

```
julia> using BenchmarkTools

julia> @btime sum($(rand(10^6)))
  155.300 μs (0 allocations: 0 bytes)
500330.6375697419
```

Note that the following:
```
julia> @btime sum(rand(10^6))
  1.644 ms (2 allocations: 7.63 MiB)
500266.9457722128
```
would be an incorrect timing as you would also measure the time of generating
of the vector.

Alternatively you can e.g. write:
```
julia> x = rand(10^6);

julia> @btime sum($x)
  154.700 μs (0 allocations: 0 bytes)
500151.95875364926
```

</details>
