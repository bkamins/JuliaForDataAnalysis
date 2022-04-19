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

# Code showing that conditional statements return a value

x = -4.0
y = if x > 0
        sqrt(x)
    else
        sqrt(-x)
    end
y

x = 9.0
y = x > 0 ? sqrt(x) : sqrt(-x)
y

# Code for listing 2.4

for i in [1, 2, 3]
    println(i, " is ", isodd(i) ? "odd" : "even")
end

# Code for listing 2.5

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

# Code for listing 2.6

x = -7
x < 0 && begin
    println(x)
    x += 1
    println(x)
    2 * x
end
x > 0 ? (println(x); x) : (x += 1; println(x); x)

# Code for section 2.3.4

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

# Code for listing 2.7

function times_two(x)
    return 2 * x
end
times_two(10)

# Code for listing 2.8

function compose(x, y=10; a, b=10)
    return x, y, a, b
end
compose(1, 2; a=3, b=4)
compose(1, 2; a=3)
compose(1; a=3)
compose(1)
compose(; a=3)

# Code for listing 2.9

times_two(x) = 2 * x
compose(x, y=10; a, b=10) = x, y, a, b

# Code showing the use of map function

map(times_two, [1, 2, 3])

# Code for listing 2.10

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

# Code for section 2.5

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
