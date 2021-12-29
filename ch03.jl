# Bogumił Kamiński, 2021

# Codes for chapter 3

# Code for listing 3.1

aq = [10.0   8.04  10.0  9.14  10.0   7.46   8.0   6.58
       8.0   6.95   8.0  8.14   8.0   6.77   8.0   5.76
      13.0   7.58  13.0  8.74  13.0  12.74   8.0   7.71
       9.0   8.81   9.0  8.77   9.0   7.11   8.0   8.84
      11.0   8.33  11.0  9.26  11.0   7.81   8.0   8.47
      14.0   9.96  14.0  8.1   14.0   8.84   8.0   7.04
       6.0   7.24   6.0  6.13   6.0   6.08   8.0   5.25
       4.0   4.26   4.0  3.1    4.0   5.39  19.0  12.50
      12.0  10.84  12.0  9.13  12.0   8.15   8.0   5.56
       7.0   4.82   7.0  7.26   7.0   6.42   8.0   7.91
       5.0   5.68   5.0  4.74   5.0   5.73   8.0   6.89]

# Code for checking size of a matrix

size(aq)
size(aq, 1)
size(aq, 2)

# Code comparing tuple to a vector

v = [1, 2, 3]
t = (1, 2, 3)
v[1]
t[1]
v[1] = 10
v
t[1] = 10

# Code for figure 3.2

using BenchmarkTools
@benchmark (1, 2, 3)
@benchmark [1, 2, 3]

# Code for section 3.1.2

using Statistics
mean(aq; dims=1)
std(aq; dims=1)

map(mean, eachcol(aq))
map(std, eachcol(aq))

map(eachcol(aq)) do col
    mean(col)
end

[mean(col) for col in eachcol(aq)]
[std(col) for col in eachcol(aq)]

# Code for section 3.1.3

[mean(aq[:, j]) for j in axes(aq, 2)]
[std(aq[:, j]) for j in axes(aq, 2)]

axes(aq, 2)
?Base.OneTo

[mean(view(aq, :, j)) for j in axes(aq, 2)]
[std(@view aq[:, j]) for j in axes(aq, 2)]

# Code for section 3.1.4

using BenchmarkTools
x = ones(10^7, 10)
@benchmark [mean(@view $x[:, j]) for j in axes($x, 2)]
@benchmark [mean($x[:, j]) for j in axes($x, 2)]
@benchmark mean($x, dims=1)

# Code for section 3.1.5

[cor(aq[:, i], aq[:, i+1]) for i in 1:2:7]
collect(1:2:7)

# Code for section 3.1.6

y = aq[:, 2]
X = [ones(11) aq[:, 1]]
X \ y
[[ones(11) aq[:, i]] \ aq[:, i+1] for i in 1:2:7]

function R²(x, y)
    X = [ones(11) x]
    model = X \ y
    prediction = X * model
    error = y - prediction
    SS_res = sum(v -> v ^ 2, error)
    mean_y = mean(y)
    SS_tot = sum(v -> (v - mean_y) ^ 2, y)
    return 1 - SS_res / SS_tot
end
[R²(aq[:, i], aq[:, i+1]) for i in 1:2:7]

?²

# Code for section 3.1.7

using Plots
scatter(aq[:, 1], aq[:, 2]; legend=false)

plot(scatter(aq[:, 1], aq[:, 2]; legend=false),
     scatter(aq[:, 3], aq[:, 4]; legend=false),
     scatter(aq[:, 5], aq[:, 6]; legend=false),
     scatter(aq[:, 7], aq[:, 8]; legend=false))

plot([scatter(aq[:, i], aq[:, i+1]; legend=false)
      for i in 1:2:7]...)

# Code for section 3.2

two_standard = Dict{Int, Int}()
for i in [1, 2, 3, 4, 5, 6]
    for j in [1, 2, 3, 4, 5, 6]
        s = i + j
        if haskey(two_standard, s)
            two_standard[s] += 1
        else
            two_standard[s] = 1
        end
    end
end
two_standard

keys(two_standard)
values(two_standard)

using Plots
scatter(collect(keys(two_standard)), collect(values(two_standard));
        legend=false, xaxis=2:12)

all_dice = [[1, x2, x3, x4, x5, x6]
            for x2 in 2:11
            for x3 in x2:11
            for x4 in x3:11
            for x5 in x4:11
            for x6 in x5:11]

for d1 in all_dice, d2 in all_dice
    test = Dict{Int, Int}()
    for i in d1, j in d2
        s = i + j
        if haskey(test, s)
            test[s] += 1
        else
            test[s] = 1
        end
    end
    if test == two_standard
        println(d1, " ", d2)
    end
end

# Code for section 3.3

aq = [10.0   8.04  10.0  9.14  10.0   7.46   8.0   6.58
       8.0   6.95   8.0  8.14   8.0   6.77   8.0   5.76
      13.0   7.58  13.0  8.74  13.0  12.74   8.0   7.71
       9.0   8.81   9.0  8.77   9.0   7.11   8.0   8.84
      11.0   8.33  11.0  9.26  11.0   7.81   8.0   8.47
      14.0   9.96  14.0  8.1   14.0   8.84   8.0   7.04
       6.0   7.24   6.0  6.13   6.0   6.08   8.0   5.25
       4.0   4.26   4.0  3.1    4.0   5.39  19.0  12.50
      12.0  10.84  12.0  9.13  12.0   8.15   8.0   5.56
       7.0   4.82   7.0  7.26   7.0   6.42   8.0   7.91
       5.0   5.68   5.0  4.74   5.0   5.73   8.0   6.89]

dataset1 = (x=aq[:, 1], y=aq[:, 2])

dataset1[1]
dataset1.x

# Code for listing 3.2

data = (set1=(x=aq[:, 1], y=aq[:, 2]),
        set2=(x=aq[:, 3], y=aq[:, 4]),
        set3=(x=aq[:, 5], y=aq[:, 6]),
        set4=(x=aq[:, 7], y=aq[:, 8]))

# Code for section 3.3.2

using Statistics
map(s -> mean(s.x), data)

map(s -> cor(s.x, s.y), data)

using GLM
model = lm(@formula(y ~ x), data.set1)

r2(model)

# Code for section 3.3.3

model.mm

x = [3, 1, 2]
sort(x)
x
sort!(x)
x

empty_field!(nt, i) = empty!(nt[i])
nt = (dict = Dict("a" => 1, "b" => 2), int=10)
empty_field!(nt, 1)
nt

# Code for section 3.4.1

x = [1 2 3]
y = [1, 2, 3]
x * y

a = [1, 2, 3]
b = [4, 5, 6]
a * b

a .* b

map(*, a, b)
[a[i] * b[i] for i in eachindex(a, b)]

eachindex(a, b)

eachindex([1, 2, 3], [4, 5])

map(*, [1, 2, 3], [4, 5])

[1, 2, 3] .* [4, 5]

# Code for section 3.4.2

[1, 2, 3] .* [4]

[1, 2, 3] .^ 2

[1, 2, 3, 4, 5, 6, 7, 8, 9, 10] .* [1 2 3 4 5 6 7 8 9 10]

["x", "y", "z"] .=> [sum minimum maximum]

abs.([1, -2, 3, -4])

abs([1, 2, 3])

string(1, 2, 3)

string.("x", 1:10)

f(i::Int) = string("got integer ", i)
f(s::String) = string("got string ", s)
f.([1, "1"])

# Code for section 3.4.3

in(1, [1, 2, 3])
in(4, [1, 2, 3])

in([1, 3, 5, 7, 9], [1, 2, 3, 4])

in.([1, 3, 5, 7, 9], [1, 2, 3, 4])

in.([1, 3, 5, 7, 9], Ref([1, 2, 3, 4]))

# Code for section 3.4.4

aq = [10.0   8.04  10.0  9.14  10.0   7.46   8.0   6.58
       8.0   6.95   8.0  8.14   8.0   6.77   8.0   5.76
      13.0   7.58  13.0  8.74  13.0  12.74   8.0   7.71
       9.0   8.81   9.0  8.77   9.0   7.11   8.0   8.84
      11.0   8.33  11.0  9.26  11.0   7.81   8.0   8.47
      14.0   9.96  14.0  8.1   14.0   8.84   8.0   7.04
       6.0   7.24   6.0  6.13   6.0   6.08   8.0   5.25
       4.0   4.26   4.0  3.1    4.0   5.39  19.0  12.50
      12.0  10.84  12.0  9.13  12.0   8.15   8.0   5.56
       7.0   4.82   7.0  7.26   7.0   6.42   8.0   7.91
       5.0   5.68   5.0  4.74   5.0   5.73   8.0   6.89]
using Statistics

mean.(eachcol(aq))

mean(eachcol(aq))

function R²(x, y)
    X = [ones(11) x]
    model = X \ y
    prediction = X * model
    error = y - prediction
    SS_res = sum(v -> v ^ 2, error)
    mean_y = mean(y)
    SS_tot = sum(v -> (v - mean_y) ^ 2, y)
    return 1 - SS_res / SS_tot
end

function R²(x, y)
    X = [ones(11) x]
    model = X \ y
    prediction = X * model
    SS_res = sum((y .- prediction) .^ 2)
    SS_tot = sum((y .- mean(y)) .^ 2)
    return 1 - SS_res / SS_tot
end

# Code for section 3.5

[]
Dict()

Float64[1, 2, 3]

Dict{UInt8, Float64}(0 => 0, 1 => 1)

UInt32(200)

Real[1, 1.0, 0x3]

v1 = Any[1, 2, 3]
eltype(v1)
v2 = Float64[1, 2, 3]
eltype(v2)
v3 = [1, 2, 3]
eltype(v2)
d1 = Dict()
eltype(d1)
d2 = Dict(1 => 2, 3 => 4)
eltype(d2)

p = 1 => 2
typeof(p)

# Code for section 3.5.1

[1, 2, 3] isa AbstractVector{Int}
[1, 2, 3] isa AbstractVector{Real}

AbstractVector{<:Real}

# Code for section 3.5.2

using Statistics
function ourcov(x::AbstractVector{<:Real},
                y::AbstractVector{<:Real})
    len = length(x)
    @assert len == length(y) > 0
    return sum((x .- mean(x)) .* (y .- mean(y))) / (len - 1)
end

ourcov(1:4, [1.0, 3.0, 2.0, 4.0])
cov(1:4, [1.0, 3.0, 2.0, 4.0])

ourcov(1:4, Any[1.0, 3.0, 2.0, 4.0])

x = Any[1, 2, 3]
identity.(x)
y = Any[1, 2.0]
identity.(y)
