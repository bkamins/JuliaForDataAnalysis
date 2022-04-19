# Bogumił Kamiński, 2021

# Codes for chapter 3

# Code for section 3.1

methods(cd)

sum isa Function

typeof(sum)
typeof(sum) == Function

supertype(typeof(sum))

function print_supertypes(T)
    println(T)
    T == Any || print_supertypes(supertype(T))
    return nothing
end
print_supertypes(Int64)

function print_subtypes(T, indent_level=0)
    println(" " ^ indent_level, T)
    for S in subtypes(T)
        print_subtypes(S, indent_level + 2)
    end
    return nothing
end
print_subtypes(Integer)

print_supertypes(typeof([1.0, 2.0, 3.0]))
print_supertypes(typeof(1:3))

AbstractVector

typejoin(typeof([1.0, 2.0, 3.0]), typeof(1:3))

# Code for section 3.2

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

# Code for section 3.3

module ExampleModule

function example()
    println("Hello")
end

end # ExampleModule

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

# - change to help mode by pressing `?` key
# - type "winsor" and press Enter

mean(winsor([8, 3, 1, 5, 7], count=1))

# Code for section 3.4

@time 1 + 2

@time(1 + 2)

@assert 1 == 2 "1 is not equal 2"
@assert(1 == 2, "1 is not equal 2")

@macroexpand @assert(1 == 2, "1 is not equal 2")

@macroexpand @time 1 + 2

# before running these codes
# define the winsorized_mean function using the code from section 3.1

using BenchmarkTools
x = rand(10^6);
@benchmark winsorized_mean($x, 10^5)
using Statistics, StatsBase
@benchmark mean(winsor($x; count=10^5))

@edit winsor(x, count=10^5)
