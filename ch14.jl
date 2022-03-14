# Bogumił Kamiński, 2022

# Codes for chapter 14

# Codes for section 14.1

using Plots
using Statistics

X = [1.0, 1.1, 1.3, 1.2, 1.2]
T = 1.0
m = 4
Y = mean(X)
K = 1.05
plot(range(0.0, T length=m+1), X;
           xlabel="T", legend=false, color="black")
hline!([Y], color="gray", lw=3, ls=:dash)
hline!([K], color="gray", lw=3, ls=:dot)
annotate!([(T, Y + 0.01, "Y"),
           (T, K + 0.01, "K"),
           (T, X[end] + 0.01, "X")])

# Codes for section 14.2

# start Julia with and additional -t4 command line switch

Threads.nthreads()

# Code for listing 14.1

function payoff_asian_sample(T, X0, K, r, s, m)::Float64
    X = X0
    sumX = X
    d = T / m
    for i in 1:m
        X *= exp((r - s^2 / 2) * d + s * sqrt(d) * randn())
        sumX += X
    end
    Y = sumX / (m + 1)
    return exp(-r * T) * max(Y - K, 0)
end

# Code for checking the results of the payoff simulation

payoff_asian_sample(1.0, 50.0, 55.0, 0.05, 0.3, 200)
payoff_asian_sample(1.0, 50.0, 55.0, 0.05, 0.3, 200)
payoff_asian_sample(1.0, 50.0, 55.0, 0.05, 0.3, 200)

# Benchmarking map

using BenchmarkTools
@btime map(i -> payoff_asian_sample(1.0, 50.0, 55.0, 0.05, 0.3, 200), 1:10_000);

using ThreadsX
@btime ThreadsX.map(i -> payoff_asian_sample(1.0, 50.0, 55.0, 0.05, 0.3, 200), 1:10_000);

# Codes for section 14.3

# Code for listing 14.2

using Statistics

function asian_value(T, X0, K, r, s, m, max_time)
    result = Float64[]
    start_time = time()
    while time() - start_time < max_time
        append!(result, ThreadsX.map(_ -> payoff_asian_sample(T, X0, K, r, s, m), 1:10_000))
    end
    n = length(result)
    mv = mean(result)
    sdv = std(result)
    lo95 = mv - 1.96 * sdv / sqrt(n)
    hi95 = mv + 1.96 * sdv / sqrt(n)
    zero = mean(==(0), result)
    return (; n, mv, lo95, hi95, zero)
end

# Code for example of the mean function

mean(x -> x ^ 2, [1, 2, 3])

eq0 = ==(0)
eq0(1)
eq0(0)

# Code for shorthand NamedTuple notation

val1 = 10
val2 = "x"
(; val1, val2)

# Testing asian_value function

@time asian_value(1.0, 50.0, 55.0, 0.05, 0.3, 200, 0.25)
@time asian_value(1.0, 50.0, 55.0, 0.05, 0.3, 200, 0.25)
@time asian_value(1.0, 50.0, 55.0, 0.05, 0.3, 200, 0.25)

# Converting NamedTuple to JSON response

using Genie
Genie.Renderer.Json.json((firstname="Bogumił", lastname="Kamiński"))

# Codes for section 14.4

# Start a new Julia session

using HTTP
using JSON3
req = HTTP.request("POST", "http://127.0.0.1:8000",
                   ["Content-Type" => "application/json"],
                   JSON3.write((K=55.0, max_time=0.25)))
JSON3.read(req.body)

HTTP.request("POST", "http://127.0.0.1:8000",
             ["Content-Type" => "application/json"],
             JSON3.write((K="", max_time=0.25)))

using DataFrames
df = DataFrame(K=30:2:80, max_time=0.25)
df.data = map(df.K, df.max_time) do K, max_time
    @show K
    @time req = HTTP.request("POST", "http://127.0.0.1:8000",
                            ["Content-Type" => "application/json"],
                            JSON3.write((;K, max_time)))
    return JSON3.read(req.body)
end;

df

all(==("OK"), getproperty.(df.data, :status))

df2 = select(df, :K, :data => ByRow(x -> x.value) => AsTable)

using Plots
plot(plot(df2.K, df2.mv; legend=false,
          xlabel="K", ylabel="expected value"),
     plot(df2.K, df2.zero; legend=false,
          xlabel="K", ylabel="probability of zero"))
