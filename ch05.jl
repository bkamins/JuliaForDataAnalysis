# Bogumił Kamiński, 2021

# Codes for chapter 5

# Code for section 5.1.1

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

# Code for section 5.1.2

[1, 2, 3] .^ [2]

[1, 2, 3] .^ 2

[1, 2, 3, 4, 5, 6, 7, 8, 9, 10] .* [1 2 3 4 5 6 7 8 9 10]

["x", "y"] .=> [sum minimum maximum]

left_matrix = ["x" "x" "x"
               "y" "y" "y"]
right_matrix = [sum minimum maximum
                sum minimum maximum]
left_matrix .=> right_matrix

abs.([1, -2, 3, -4])

abs([1, 2, 3])

string(1, 2, 3)

string.("x", 1:10)

f(i::Int) = string("got integer ", i)
f(s::String) = string("got string ", s)
f.([1, "1"])

# Code for section 5.1.3

in(1, [1, 2, 3])
in(4, [1, 2, 3])

1 in [1, 2, 3]
4 in [1, 2, 3]

in([1, 3, 5, 7, 9], [1, 2, 3, 4])

in([1, 3, 5, 7, 9], [1, 2, 3, 4, [1, 3, 5, 7, 9]])

in.([1, 3, 5, 7, 9], [1, 2, 3, 4])

in.([1, 3, 5, 7, 9], Ref([1, 2, 3, 4]))

isodd.([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] .+ [1 2 3 4 5 6 7 8 9 10])

Matrix{Any}(isodd.([1, 2, 3, 4, 5, 6, 7, 8, 9, 10] .* [1 2 3 4 5 6 7 8 9 10]))

# Code for section 5.1.4

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

# Code for section 5.2

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
eltype(v3)
d1 = Dict()
eltype(d1)
d2 = Dict(1 => 2, 3 => 4)
eltype(d2)

p = 1 => 2
typeof(p)

# Code for section 5.2.1

[1, 2, 3] isa AbstractVector{Int}
[1, 2, 3] isa AbstractVector{Real}

AbstractVector{<:Real} == AbstractVector{T} where T<:Real

# Code for section 5.2.2

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

# Code for section 5.3

using Random
Random.seed!(1234);
cluster1 = randn(100, 5) .- 1
cluster2 = randn(100, 5) .+ 1

data5 = vcat(cluster1, cluster2)

using PyCall
manifold = pyimport("sklearn.manifold")

# Optional code to run if the pyimport("sklearn.manifold") fails
# There is no need to run it if the above operation worked
using Conda
Conda.add("scikit-learn")

tsne = manifold.TSNE(n_components=2, init="random",
                     learning_rate="auto", random_state=1234)
data2 = tsne.fit_transform(data5)

using Plots
scatter(data2[:, 1], data2[:, 2];
        color=[fill("black", 100); fill("gold", 100)],
        legend=false)
