# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 2

# Problems

### Exercise 1

Consider the following code:
```
x = [1, 2]
y = x
y[1] = 10
```
What is the value of `x[1]` and why?

### Exercise 2

How can you type `⚡ = 1`. Check if this operation succeeds and what is its result.

### Exercise 3

What will be the value of variable `x` after running of the following code and why?
```
x = 0.0
for i in 1:7_000_000
    global x += 1/7
end
x /= 1_000_000
```

### Exercise 4

Express the type `Matrix{Bool}` using `Array` type.

### Exercise 5

Let `x` be a vector. Write code that prints an error if `x` is empty
(has zero elements)

### Exercise 6

Write a function called `exec` that takes two values `x` and `y` and a function
accepting two arguments, call it `op` and returns `op(x, y)`. Make `+` to be
the default value of `op`.

### Exercise 7

Write a function that calculates a sum of absolute values of values stored in
a collection passed to it.

### Exercise 8

Write a function that swaps first and last element in an array in place.

### Exercise 9

Write a loop in global scope that calculates the sum of cubes of numbers from
`1` to `10^6`. Next use the `sum` function to perform the same computation.
What is the difference in timing of these operations?

### Exercise 10

Explain the value of the result of summation obtained in exercise 9.

# Solutions

<details>

<summary>Show!</summary>

### Exercise 1

`x[1]` will be `10` because `y = x` is not copying data but it binds
the same value both to variable `x` and `y`.

### Exercise 2

In help mode (activated by `?`) copy-paste `⚡` to get:
```
help?> ⚡
"⚡" can be typed by \:zap:<tab>
```
After the `⚡ = 1` operation a new variable `⚡` is defined and it is bound
to value `1`.

### Exercise 3

`x` will have value `0.9999999999242748`. This value is below `1.0` because
representation of `1/7` using `Float64` type is less than rational number 1/7,
and the error accumulates when we do addition multiple times.

*Extra*: You can check that indeed that `Float64` representation is a bit less
than rational 1/7 by increasing the precision of computations using the `big`
function:
```
julia> big(1/7) # convert Floa64 to high-precision float
0.142857142857142849212692681248881854116916656494140625

julia> 1/big(7) # construct high-precision float directly
0.1428571428571428571428571428571428571428571428571428571428571428571428571428568
```
As you can see there is a difference at 17th place after decimal dot where we
have `4` vs `5`.

### Exercise 4

It is `Array{Bool, 2}`. You immediately get this information in REPL:
```
julia> Matrix{Bool}
Matrix{Bool} (alias for Array{Bool, 2})
```

### Exercise 5

You can do it like this:
```
length(x) == 0 && println("x is empty")
```

*Extra*: typically in such case one would use the `isempty` function and throw
an exception instead of just printing information (here I assume that `x` was
passed as an argument to the function):
```
isempty(x) && throw(ArgumentError("x is not allowed to be empty"))
```

### Exercise 6

Here are two ways to define the `exec` function:
```
exec1(x, y, op=+) = op(x, y)
exec2(x, y; op=+) = op(x, y)
```
The first of them uses positional arguments, and the second a keyword argument.
Here is a difference in how they would be called:
```
julia> exec1(2, 3, *)
6

julia> exec2(2, 3; op=*)
6
```

### Exercise 7

Such a function can be written as:
```
sumabs(x) = sum(abs, x)
```

### Exercise 8

This can be written for example as:
```
function swap!(x)
    f = x[1]
    x[1] = x[end]
    x[end] = f
    return x
end
```

*Extra* A more advanced way to write this function would be:
```
function swap!(x)
    if length(x) > 1
        x[begin], x[end] = x[end], x[begin]
    end
    return x
end
```
Note the differences in the code:
* we use `begin` instead of `1` to get the first element. This is a safer
  practice since some collections in Julia do not use 1-based indexing (in
  practice you are not likely to see them, so this comment is most relevant
  for package developers)
* if there are `0` or `1` element in the collection the function does not do
  anything (depending on the context we might want to throw an error instead)
* in `x[begin], x[end] = x[end], x[begin]` we perform two assignments at the
  same time to avoid having to use a temporaty variable `f` (this operation
  is technically called tuple destructuring; we discuss it in later chapters of
  the book)

### Exercise 9

We used `@time` macro in chapter 1.

Version in global scope:
```
julia> s = 0
0

julia> @time for i in 1:10^6
           global s += i^3
       end
  0.076299 seconds (2.00 M allocations: 30.517 MiB, 10.47% gc time)
```

Version with a function using a `sum` function:
```
julia> sum3(n) = sum(x -> x^3, 1:n)
sum3 (generic function with 1 method)

julia> @time sum3(10^6)
  0.000012 seconds
-8222430735553051648
```

Version with `sum` function in global scope:
```
julia> @time sum(x -> x^3, 1:10^6)
  0.027436 seconds (48.61 k allocations: 2.558 MiB, 99.75% compilation time)
-8222430735553051648

julia> @time sum(x -> x^3, 1:10^6)
  0.025744 seconds (48.61 k allocations: 2.557 MiB, 99.76% compilation time)
-8222430735553051648
```

As you can see using a loop in global scope is inefficient. It leads to
many allocations and slow execution.

Using a `sum3` function leads to fastest execution. You might ask why using
`sum(x -> x^3, 1:10^6)` in global scope is slower. The reason is that an
anonymous function `x -> x^3` is defined anew each time this operation is called
which forces compilation of the `sum` function (but it is still faster than
the loop in global scope).

For a reference check the function with a loop inside it:
```
julia> function sum3loop(n)
           s = 0
           for i in 1:n
               s += i^3
           end
           return s
       end
sum3loop (generic function with 1 method)

julia> @time sum3loop(10^6)
  0.001378 seconds
-8222430735553051648
```
This is also much faster than a loop in global scope.

### Exercise 10

In exercise 9 we note that the result is `-8222430735553051648` which is a
negative value, although we are adding cubes of positive values. The
reason of the problem is that operations on integers overflow. If you
are working with numbers larger that can be stored in `Int` type, which is:
```
julia> typemax(Int)
9223372036854775807
```
use `big` numbers that we discussed in *Exercise 3*:
```
julia> @time sum(x -> big(x)^3, 1:10^6)
  0.833234 seconds (11.05 M allocations: 236.113 MiB, 23.77% gc time, 2.63% compilation time)
250000500000250000000000
```
Now we get a correct result, at the cost of slower computation.

</details>
