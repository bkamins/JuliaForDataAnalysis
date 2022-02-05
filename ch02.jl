# Bogumił Kamiński, 2021

# Codes for chapter 2

# Code for listing 2.1

1
true
"Hello world!"
0.1
[1, 2, 3]

# Code for listing 2.2

typeof(1)
typeof(true)
typeof("Hello world!")
typeof(0.1)
typeof([1, 2, 3])

# Code for showing bit representation of numbers

bitstring(1)
bitstring(1.0)
bitstring(Int8(1))

# Code showing to what Int alias expands

Int

# Code for checking if value is of some type

[1, 2, 3] isa Vector{Int}
[1, 2, 3] isa Array{Int64, 1}

# Code for section 2.2

x = 1
y = [1, 2, 3]

x = 1
x
typeof(x)
x = 0.1
x
typeof(x)

Kamiński = 1
x₁ = 0.5
ε = 0.0001

?₁
?ε

# Code for listing 2.3

x = -7
if x > 0
    println("positive")
elseif x < 0
    println("negative")
elseif x == 0
    println("zero")
else
    println("unexpected condition")
end

# Code showing that logical condition must be Bool

x = -7
if x
    println("condition was true")
end

# Code showing comparisons against NaN

NaN > 0
NaN >= 0
NaN < 0
NaN <= 0
NaN == 0

NaN != 0
NaN != NaN

# Code showing that floating point arithmetic is only approximate

0.1 + 0.2 == 0.3

0.1 + 0.2

isapprox(0.1 + 0.2, 0.3)

0.1 + 0.2 ≈ 0.3

# Code showing combining conditions

x = -7
x > 0 && x < 10
x < 0 || log(x) > 10

x = -7
log(x)

# Code showing typical one-line conditional execution expressions

x > 0 && println(x)

if x > 0
    println(x)
end

x > 0 || println(x)

if !(x > 0)
    println(x)
end

x = -7
x < 0 && println(x^2)
iseven(x) || println("x is odd")

x = -7
if x < 0
    println(x^2)
end
if !iseven(x)
    println("x is odd")
end

x = -7
if x < 0 && x^2
    println("inside if")
end

# Code showing ternary operator

x > 0 ? sqrt(x) : sqrt(-x)

if x > 0
    sqrt(x)
else
    sqrt(-x)
end

x = -7
x > 0 ? println("x is positive") : println("x is not positive")

# Code from listing 2.4

for i in [1, 2, 3]
    println(i, " is ", isodd(i) ? "odd" : "even")
end

# Code from listing 2.5

i = 1
while i < 4
    println(i, " is ", isodd(i) ? "odd" : "even")
    global i += 1
end

# Code showing break and continue keywords

i = 0
while true
    global i += 1
    i > 6 && break
    isodd(i) && continue
    println(i, " is even")
end

# Code from listing 2.6

x = -7
x < 0 && begin
    println(x)
    x += 1
    println(x)
    2 * x
end
x > 0 ? (println(x); x) : (x += 1; println(x); x)

# Code from section 2.3.4

x = [8, 3, 1, 5, 7]
k = 1

y = sort(x)

for i in 1:k
    y[i] = y[k + 1]
    y[end - i + 1] = y[end - k]
end
y

s = 0
for v in y
    global s += v
end
s
s / length(y)

# Code from listing 2.7

function times_two(x)
    return 2 * x
end
times_two(10)

# Code from listing 2.8

function compose(x, y=10; a, b=10)
    return x, y, a, b
end
compose(1, 2; a=3, b=4)
compose(1, 2; a=3)
compose(1; a=3)
compose(1)
compose(; a=3)

# Code from listing 2.9

times_two(x) = 2 * x
compose(x, y=10; a, b=10) = x, y, a, b

# Code showing the use of map function

map(times_two, [1, 2, 3])

# Code from listing 2.10

map(x -> 2 * x, [1, 2, 3])

# Code showing sum taking a function as a first argument

sum(x -> x ^ 2, [1, 2, 3])

# Code showing do-end syntax

sum([1, 2, 3]) do x
    println("processing ", x)
    return x ^ 2
end

# Code showing the difference between sort and sort!

x = [5, 1, 3, 2]
sort(x)
x
sort!(x)
x

# Code showing a simple implementation of winsorized_mean function

function winsorized_mean(x, k)
    y = sort(x)
    for i in 1:k
        y[i] = y[k + 1]
        y[end - i + 1] = y[end - k]
    end
    s = 0
    for v in y
        s += v
    end
    return s / length(y)
end
winsorized_mean([8, 3, 1, 5, 7], 1)

# Code from section 2.5

function fun1()
    x = 1
    return x + 1
end
fun1()
x

function fun2()
    if true
        x = 10
    end
    return x
end
fun2()

function fun3()
    x = 0
    for i in [1, 2, 3]
        if i == 2
            x = 2
        end
    end
    return x
end
fun3()

function fun4()
    for i in [1, 2, 3]
        if i == 2
            x = 2
        end
    end
    return x
end
fun4()

function fun5()
    for i in [1, 2, 3]
        if i == 1
            x = 1
        else
            x += 1
        end
        println(x)
    end
end
fun5()

function fun6()
    x = 0
    for i in [1, 2, 3]
        if i == 1
            x = 1
        else
            x += 1
        end
        println(x)
    end
end
fun6()

# Code from section 2.6

methods(cd)

sum isa Function

typeof(sum)
typeof(sum) == Function

supertype(typeof(sum))

function traverse(T)
    println(T)
    T == Any || traverse(supertype(T))
    return nothing
end
traverse(Int64)

function print_subtypes(T, indent_level=0)
    println(" " ^ indent_level, T)
    for S in subtypes(T)
        print_subtypes(S, indent_level + 2)
    end
    return nothing
end
print_subtypes(Integer)

traverse(typeof([1.0, 2.0, 3.0]))
traverse(typeof(1:3))

AbstractVector

typejoin(typeof([1.0, 2.0, 3.0]), typeof(1:3))

# Code from section 2.7

fun(x) = println("unsupported type")
fun(x::Number) = println("a number was passed")
fun(x::Float64) = println("a Float64 value")
methods(fun)

fun("hello!")
fun(1)
fun(1.0)

bar(x, y) = "no numbers passed"
bar(x::Number, y) = "first argument is a number"
bar(x, y::Number) = "second argument is a number"
bar("hello", "world")
bar(1, "world")
bar("hello", 2)
bar(1, 2)

bar(x::Number, y::Number) = "both arguments are numbers"
bar(1, 2)
methods(bar)

function winsorized_mean(x::AbstractVector, k::Integer)
    k >= 0 || throw(ArgumentError("k must be non-negative"))
    length(x) > 2 * k || throw(ArgumentError("k is too large"))
    y = sort!(collect(x))
    for i in 1:k
        y[i] = y[k + 1]
        y[end - i + 1] = y[end - k]
    end
    return sum(y) / length(y)
end

winsorized_mean([8, 3, 1, 5, 7], 1)
winsorized_mean(1:10, 2)
winsorized_mean(1:10, "a")
winsorized_mean(10, 1)

winsorized_mean(1:10, -1)
winsorized_mean(1:10, 5)

# Code from section 2.8

import Statistics
x = [1, 2, 3]
mean(x)
Statistics.mean(x)

using Statistics
mean(x)

# start a fresh Julia session before running this code
mean = 1
using Statistics
mean

# start a fresh Julia session before running this code
using Statistics
mean([1, 2, 3])
mean = 1

# start a fresh Julia session before running this code
using Statistics
mean = 1
mean([1, 2, 3])

# start a fresh Julia session before running this code
using Statistics
using StatsBase
?winsor
mean(winsor([8, 3, 1, 5, 7], count=1))

# Code from section 2.9

@time 1 + 2

@time(1 + 2)

@assert 1 == 2 "1 is not equal 2"
@assert(1 == 2, "1 is not equal 2")

@macroexpand @assert(1 == 2, "1 is not equal 2")

@macroexpand @time 1 + 2

# before running these codes
# define the winsorized_mean function using the code from section 2.7

using BenchmarkTools
x = rand(10^6);
@benchmark winsorized_mean($x, 10^5)
using Statistics, StatsBase
@benchmark mean(winsor($x; count=10^5))

@edit winsor(x, count=10^5)
