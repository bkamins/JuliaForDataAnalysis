---
marp: true
---

# Julia for Data Analysis

## Chapter 2: Getting started with Julia

### Bogumił Kamiński

https://github.com/bkamins/JuliaForDataAnalysis

---

# Outline

1. Values
2. Variables
3. Control flow
3.1. Conditional evaluation
3.2. Loops
3.3. Compound expressions
4. Defining functions
5. Scoping rules

---

# Values

* A *value* is a representation of some entity that is stored in computer's
memory and can be manipulated by Julia program.
* Every value is a result of evaluation of some Julia expression.
* Example values created by evaluation of *literals*:

```
julia> 0.1
0.1

julia> "Hello world!"
"Hello world!"

julia> [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3
```

---

# Types

* Each value has a type, which you can check using the `typeof` function.
* When you define a function you optionally can define the types of arguments
  that the function accepts.
* Example types of values:

```
julia> typeof(0.1)
Float64

julia> typeof("Hello world!")
String

julia> typeof([1, 2, 3])
Vector{Int64} (alias for Array{Int64, 1})
```

---

# Checking memory layout of numbers

* Numbers in Julia can have different types (e.g. `Int64`, `Float64`, `Int8`).
* Each such type can use a different memory layout to represent the same
  mathematical value.
* Examples of representation of *one*:

```
julia> bitstring(1)
"0000000000000000000000000000000000000000000000000000000000000001"

julia> bitstring(1.0)
"0011111111110000000000000000000000000000000000000000000000000000"

julia> bitstring(Int8(1))
"00000001"
```

---

# Integer type

On 64-bit machines integers in Julia by default use 64-bit representation
(`Int64` type). As a shorthand you can use `Int` alias type name instead:

```
julia> Int
Int64
```

---

# Container types typically have parameters in Julia

```
julia> typeof([1, 2, 3])
Vector{Int64} (alias for Array{Int64, 1})
```

* `Vector{Int64}` tells us that `[1, 2, 3]` is a vector that can store
  integer numbers; the `Int64` part is a parameter of `Vector`;
* `Array{Int64, 1}` is another way to write the same; now we have two parameters:
   1. element type that our array can store (`Int64`, an integer);
   2. dimension of our array (`1`, a vector).

---

# Checking if value has some type

You can check if some value has some type using the `isa` operator:

```
julia> [1, 2, 3] isa Vector{Int}
true

julia> [1, 2, 3] isa Array{Int64, 1}
true
```

---

# Variables

* You can bind a value to a variable name using the assignment operator `=`:

```
julia> x = 1
1

julia> y = [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3
```

* The process of binding does not involve copying of values.
  Python also follows this approach.
  In R this is not the case.

---

# Only values have types in Julia

You can, in general assign values of different types to the same variable name:

```
julia> x = 1
1

julia> typeof(x)
Int64

julia> x = 0.1
0.1

julia> typeof(x)
Float64
```

Although this is allowed it is usually not recommended.

---

# You can use Unicode characters in variable names

```
julia> Kamiński = 1
1

julia> x₁ = 0.5
0.5

julia> ε = 0.0001
0.0001
```

In Julia REPL, VS Code ect., you can easily type such characters:

```
help?> ₁
"₁" can be typed by \_1<tab>

help?> ε
"ε" can be typed by \varepsilon<tab>
```

---

# The `if` statement

```
julia> x = -7
-7

julia> if x > 0
           println("positive")
       elseif x < 0
           println("negative")
       elseif x == 0
           println("zero")
       else
           println("unexpected condition")
       end
negative
```

---

# Conditions must be Boolean values

```
julia> x = -7
-7

julia> if x
           println("condition was true")
       end
ERROR: TypeError: non-boolean (Int64) used in boolean context
```

---

# Be careful with numeric comparisons of floats

```
julia> NaN > 0
false

julia> NaN < 0
false

julia> NaN == 0
false

julia> NaN != 0
true

julia> NaN != NaN
true

julia> 0.1 + 0.2 == 0.3
false
```

---

# Combining logical conditions with `&&` and `||`

```
julia> x = -7
-7

julia> x > 0 && x < 10
false

julia> x < 0 || log(x) > 10
true
```

---

# Short-circut evaluation

`&&` and `||` evaluate only as many conditions (starting from the leftmost) as
is needed to determine the logical value of the whole expression.

```
julia> x = -7
-7

julia> log(x)
ERROR: DomainError with -7.0:
log will only return a complex result if called with a complex argument. Try log(Complex(x)).

julia> x < 0 || log(x) > 10
true
```

---

# One-line conditional evaluation using `&&` and `||`

The codes below use short-circut evaluation:

```
julia> x = -7
-7

julia> x < 0 && println(x^2)
49

julia> iseven(x) || println("x is odd")
x is odd
```

---

# Ternary operator

Julia supports the *ternary operator* borrowed from the C programming language.

```
x > 0 ? sqrt(x) : sqrt(-x)
```

is equivalent to writing:

```
if x > 0
    sqrt(x)
else
    sqrt(-x)
end
```

---

# Conditional statements return a value

```
julia> x = -4.0
-4.0

julia> y = if x > 0
               sqrt(x)
           else
               sqrt(-x)
           end
2.0

julia> y
2.0
```

---

# Example `for` loop

```
julia> for i in [1, 2, 3]
           println(i, " is ", isodd(i) ? "odd" : "even")
       end
1 is odd
2 is even
3 is odd
```

---

# Example `while` loop

```
julia> i = 1
1

julia> while i < 4
           println(i, " is ", isodd(i) ? "odd" : "even")
           global i += 1
       end
1 is odd
2 is even
3 is odd
```

We use `global` keyword in the loop as we want to update the `i` variable which
is in global scope.

---

# Standard `break` and `continue` keywords are supported in loops

```
julia> i = 0
0

julia> while true
           global i += 1
           i > 6 && break
           isodd(i) && continue
           println(i, " is even")
       end
2 is even
4 is even
6 is even
```

---

# Compound expression using `begin`-`end` block

```
julia> x = -7
-7

julia> x < 0 && begin
           println(x)
           x += 1
           println(x)
           2 * x
       end
-7
-6
-12
```

The value of the compound expression is the value of the last expression
inside it (`-12` in our case).

---

# Compound expression using semicolon `;`

If your code is short you can wrap several expressions in parentheses
and separate them using semicolon `;`:

```
julia> x = -7
-7

julia> x > 0 ? (println(x); x) : (x += 1; println(x); x)
-5
-5
```

---

# You can use the `function` keyword to define a function

```
julia> function times_two(x)
           return 2 * x
       end
times_two (generic function with 1 method)

julia> times_two(10)
20
```

---

# Functions allow positional and keyword arguments separated by `;` with optional default values

```
julia> function compose(x, y=10; a, b=10)
           return x, y, a, b
       end
compose (generic function with 2 methods)

julia> compose(1, 2; a=3, b=4)
(1, 2, 3, 4)

julia> compose(1, 2; a=3)
(1, 2, 3, 10)

julia> compose(1; a=3)
(1, 10, 3, 10)

julia> compose(1)
ERROR: UndefKeywordError: keyword argument a not assigned

julia> compose(; a=3)
ERROR: MethodError: no method matching g(; a=3)
```

---

# Passing arguments to functions in Julia

If you pass a value to a function Julia performs a binding of the function
argument name to this value. This feature is called *pass-by-sharing* and means
that Julia never copies data when arguments are passed to a function.

This is a behavior that you might know from Python, but is different from e.g.,
R, where copying of function arguments is performed.

---

# Short syntax for creation simple functions

You can use the assignment operator to create one-line functions:

```
julia> times_two(x) = 2 * x
times_two (generic function with 1 method)

julia> compose(x, y=10; a, b=10) = x, y, a, b
compose (generic function with 2 methods)
```

---

# Functions are first class objects in Julia

You can pass functions as arguments to other functions:

```
julia> map(times_two, [1, 2, 3])
3-element Vector{Int64}:
 2
 4
 6
```

---

# You can define anonymous functions using the `->` operator

```
julia> map(x -> 2 * x, [1, 2, 3])
3-element Vector{Int64}:
 2
 4
 6

julia> sum(x -> x ^ 2, [1, 2, 3])
14
```

---

# Julia supports `do` blocks

If a function takes another function as its first argument you can conveniently
define it using a `do` block:

```
julia> sum([1, 2, 3]) do x
           println("processing ", x)
           return x ^ 2
       end
processing 1
processing 2
processing 3
14
```

---

# The `!` character in function names

Often you will see an exclamation mark (`!`) at the end of the function name,
e.g., `sort!`. There is a convention that developers are recommended to add `!`
at the end of the functions they create if such functions modify their arguments.

```
julia> x = [5, 1, 3, 2];

julia> sort(x); # returns a new vector; x is not changed

julia> sort!(x); # changes x in-place
```

---

# Variable scoping rules in Julia (simplified)

The following constructs we have learned till now create a new scope (*local scope*):
* functions, anonymous functions, `do`-`end` blocks;
* `for` and `while` loops.

Notably the `if` blocks and the `begin`-`end` blocks do not introduce a new
scope. This means that variables defined in such blocks leak out to the
enclosing scope.
