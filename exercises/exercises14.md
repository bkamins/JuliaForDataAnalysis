# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 14

# Problems

### Exercise 1

Write a simulator that takes one parameter `n`. Next we assume we draw
`n` times from this set with replacement. The simulator should return the
average number of items from this set that were drawn at least once.

Call the function running this simulation `boot`.

<details>
<summary>Solution</summary>

There are many other approaches you could use:

```
using Statistics

function boot(n::Integer)
    table = falses(n)
    for _ in 1:n
        table[rand(1:n)] = true
    end
    return mean(table)
end
```

</details>

### Exercise 2

Now write a function `simboot` that takes parameters `n` and `k` and runs
the simulation defined in the `boot` function `k` times. It should return
a named tuple storing `k`, `n`, mean of produced values, and ends of
approximated 95% confidence interval of the result.

Make this function single threaded. Check how long
this function runs for `n=1000` and `k=1_000_000`.

<details>
<summary>Solution</summary>

```
function simboot(k::Integer, n::Integer)
    result = [boot(n) for _ in 1:k]
    mv = mean(result)
    sdv = std(result)
    lo95 = mv - 1.96 * sdv / sqrt(k)
    hi95 = mv + 1.96 * sdv / sqrt(k)
    return (; k, n, mv, lo95, hi95)
end
```

We run it twice to make sure everything is compiled:
```
julia> @time simboot(1000, 1_000_000)
  7.113436 seconds (3.00 k allocations: 119.347 MiB, 0.24% gc time)
(k = 1000, n = 1000000, mv = 0.632128799, lo95 = 0.6321282057815055, hi95 = 0.6321293922184944)

julia> @time simboot(1000, 1_000_000)
  7.058031 seconds (3.00 k allocations: 119.347 MiB, 0.19% gc time)
(k = 1000, n = 1000000, mv = 0.632112942, lo95 = 0.6321123461087246, hi95 = 0.6321135378912754)
```

We see that on my computer the run time is around 7 seconds.

</details>

### Exercise 3

Now rewrite this simulator to be multi threaded. Use 4 cores for benchmarking.
Call the function `simbootT`. Check how long this function runs for `n=1000` and
`k=1_000_000`.

<details>
<summary>Solution</summary>

```
using ThreadsX

function simbootT(k::Integer, n::Integer)
    result = ThreadsX.map(i -> boot(n), 1:k)
    mv = mean(result)
    sdv = std(result)
    lo95 = mv - 1.96 * sdv / sqrt(k)
    hi95 = mv + 1.96 * sdv / sqrt(k)
    return (; k, n, mv, lo95, hi95)
end
```

Here is the timing for four threads:
```
julia> @time simbootT(1000, 1_000_000)
  2.390795 seconds (3.37 k allocations: 119.434 MiB)
(k = 1000, n = 1000000, mv = 0.632117067, lo95 = 0.6321164425245517, hi95 = 0.6321176914754484)

julia> @time simbootT(1000, 1_000_000)
  2.435889 seconds (3.38 k allocations: 119.434 MiB, 1.13% gc time)
(k = 1000, n = 1000000, mv = 0.6321205520000001, lo95 = 0.6321199284351448, hi95 = 0.6321211755648554)
```

Indeed we see a significant performance improvement.

</details>

### Exercise 4

Now rewrite `boot` and `simbootT` to perform less allocations. Achieve this by
making sure that all allocated objects are passed to `boot` function (so that it
does not do any allocations internally). Call these new functions `boot!` and
`simbootT2`. You might need to use the `Threads.threadid` and `Threads.nthreads`
functions.

<details>
<summary>Solution</summary>

```
function boot!(n::Integer, pool)
    table = pool[Threads.threadid()]
    fill!(table, false)
    for _ in 1:n
        table[rand(1:n)] = true
    end
    return mean(table)
end

function simbootT2(k::Integer, n::Integer)
    pool = [falses(n) for _ in 1:Threads.nthreads()]
    result = ThreadsX.map(i -> boot!(n, pool), 1:k)
    mv = mean(result)
    sdv = std(result)
    lo95 = mv - 1.96 * sdv / sqrt(k)
    hi95 = mv + 1.96 * sdv / sqrt(k)
    return (; k, n, mv, lo95, hi95)
end
```

In the solution the `pool` vector keeps `table` vector
individually for each thread. Let us test the timing:

```
julia> @time simbootT2(1000, 1_000_000)
  2.424664 seconds (3.69 k allocations: 746.042 KiB, 1.75% compilation time: 5% of which was recompilation)
(k = 1000, n = 1000000, mv = 0.632119321, lo95 = 0.6321186866457794, hi95 = 0.6321199553542206)

julia> @time simbootT2(1000, 1_000_000)
  2.340694 seconds (391 allocations: 586.453 KiB)
(k = 1000, n = 1000000, mv = 0.6321318470000001, lo95 = 0.6321312368042945, hi95 = 0.6321324571957058)
```

Indeed, we see that the number of allocations was decreased, which should lower
GC usage. However, the runtime of the simulation is similar since in this task
memory allocation does not account for a significant portion of the runtime.

</details>

### Exercise 5

Use either of the solutions we have developed in the previous exercises to
create a web service taking `k` and `n` parameters and returning the values
produced by `boot` functions and time to run the simulation. You might want to
use the `@timed` macro in your solution.

Start the server.

<details>
<summary>Solution</summary>

I used the simplest single-threaded code here; this is a complete
code of the web service:

```
using Genie
using Statistics

function boot(n::Integer)
    table = falses(n)
    for _ in 1:n
        table[rand(1:n)] = true
    end
    return mean(table)
end

function simboot(k::Integer, n::Integer)
    result = [boot(n) for _ in 1:k]
    mv = mean(result)
    sdv = std(result)
    lo95 = mv - 1.96 * sdv / sqrt(k)
    hi95 = mv + 1.96 * sdv / sqrt(k)
    return (; k, n, mv, lo95, hi95)
end

Genie.config.run_as_server = true

Genie.Router.route("/", method=POST) do
  message = Genie.Requests.jsonpayload()
  return try
      k = message["k"]
      n = message["n"]
      value, time = @timed simboot(k, n)
      Genie.Renderer.Json.json((status="OK", time=time, value=value))
  catch
      Genie.Renderer.Json.json((status="ERROR", time="", value=""))
  end
end

Genie.Server.up()
```

</details>

### Exercise 6

Query the server started in the exercise 5 with
the following parameters:
* `k=1000` and `n=1000`
* `k=1.5` and `n=1000`

<details>
<summary>Solution</summary>

```
julia> using HTTP

julia> using JSON3

julia> HTTP.post("http://127.0.0.1:8000",
                 ["Content-Type" => "application/json"],
                 JSON3.write((k=1000, n=1000)))
HTTP.Messages.Response:
"""
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Server: Genie/Julia/1.8.2
Transfer-Encoding: chunked

{"status":"OK","time":0.2385469,"value":{"k":1000,"n":1000,"mv":0.6323970000000001,"lo95":0.6317754483212517,"hi95":0.6330185516787485}}"""

julia> HTTP.post("http://127.0.0.1:8000",
                 ["Content-Type" => "application/json"],
                 JSON3.write((k=1.5, n=1000)))
HTTP.Messages.Response:
"""
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Server: Genie/Julia/1.8.2
Transfer-Encoding: chunked

{"status":"ERROR","time":"","value":""}"""
```

As expected we got a positive answer the first time and an error on the second call.

</details>

### Exercise 7

Collect the data generated by a web service into the `df` data frame for
`k = [10^i for i in 3:6]` and `n = [10^i for i in 1:3]`.

<details>
<summary>Solution</summary>

```
using DataFrames

df = DataFrame()
for k in [10^i for i in 3:6], n in [10^i for i in 1:3]
    @show k, n
    req = HTTP.post("http://127.0.0.1:8000",
                    ["Content-Type" => "application/json"],
                    JSON3.write((; k, n)))
    push!(df, NamedTuple(JSON3.read(req.body)))
end
```

Note that I convert `JSON3.Object` into a `NamedTuple` to easily `push!`
it into the `df` data frame.

Let us have a look at the produced data frame:

```
julia> df
12×3 DataFrame
 Row │ status  time       value
     │ String  Float64    Object…
─────┼──────────────────────────────────────────────────────
   1 │ OK      0.0006784  {\n      "k": 1000,\n      "n": …
   2 │ OK      0.0038374  {\n      "k": 1000,\n      "n": …
   3 │ OK      0.0150844  {\n      "k": 1000,\n      "n": …
   4 │ OK      0.0014071  {\n      "k": 10000,\n      "n":…
   5 │ OK      0.008443   {\n      "k": 10000,\n      "n":…
   6 │ OK      0.0700319  {\n      "k": 10000,\n      "n":…
   7 │ OK      0.0253826  {\n      "k": 100000,\n      "n"…
   8 │ OK      0.0795937  {\n      "k": 100000,\n      "n"…
   9 │ OK      0.708287   {\n      "k": 100000,\n      "n"…
  10 │ OK      0.160286   {\n      "k": 1000000,\n      "n…
  11 │ OK      0.803433   {\n      "k": 1000000,\n      "n…
  12 │ OK      7.23958    {\n      "k": 1000000,\n      "n…
```

</details>

### Exercise 8

Replace the `value` column in the `df` data frame by its contents in-place.

<details>
<summary>Solution</summary>

```
julia> select!(df, :status, :time, :value => AsTable)
12×7 DataFrame
 Row │ status  time       k        n      mv        lo95      hi95
     │ String  Float64    Int64    Int64  Float64   Float64   Float64
─────┼─────────────────────────────────────────────────────────────────
   1 │ OK      0.0006784     1000     10  0.6469    0.640745  0.653055
   2 │ OK      0.0038374     1000    100  0.63508   0.633035  0.637125
   3 │ OK      0.0150844     1000   1000  0.632178  0.631581  0.632775
   4 │ OK      0.0014071    10000     10  0.65239   0.650425  0.654355
   5 │ OK      0.008443     10000    100  0.634456  0.633845  0.635067
   6 │ OK      0.0700319    10000   1000  0.63207   0.631878  0.632262
   7 │ OK      0.0253826   100000     10  0.651411  0.650793  0.652029
   8 │ OK      0.0795937   100000    100  0.634     0.633807  0.634193
   9 │ OK      0.708287    100000   1000  0.63224   0.632179  0.632302
  10 │ OK      0.160286   1000000     10  0.65129   0.651095  0.651486
  11 │ OK      0.803433   1000000    100  0.633995  0.633934  0.634056
  12 │ OK      7.23958    1000000   1000  0.63232   0.632301  0.63234
```

</details>

### Exercise 9

Checks that execution time roughly scales proportionally to the product
of `k` times `n`.

<details>
<summary>Solution</summary>

```
julia> using DataFramesMeta

julia> @chain df begin
           @rselect(:k, :n, :avg_time = :time / (:k * :n))
           unstack(:k, :n, :avg_time)
       end
4×4 DataFrame
 Row │ k        10          100         1000
     │ Int64    Float64?    Float64?    Float64?
─────┼─────────────────────────────────────────────
   1 │    1000  6.784e-8    3.8374e-8   1.50844e-8
   2 │   10000  1.4071e-8   8.443e-9    7.00319e-9
   3 │  100000  2.53826e-8  7.95937e-9  7.08287e-9
   4 │ 1000000  1.60286e-8  8.03433e-9  7.23958e-9
```

We see that indeed this is the case. For large `k` and `n` the average time per
single sample stabilizes (for small values the runtime is low so the timing is
more affected by external noise and the other operations that the functions do
affect the results more).

</details>

### Exercise 10

Plot the expected fraction of seen elements in the set as a function of
`n` by `k` along with 95% confidence interval around these values.

<details>
<summary>Solution</summary>

```
using Plots
gdf = groupby(df, :k, sort=true)
plot([bar(string.(g.n), g.mv;
          ylim=(0.62, 0.66), xlabel="n", ylabel="estimate",
          legend=false, title=first(g.k),
          yerror=(g.mv - g.lo95, g.hi95-g.mv)) for g in gdf]...)
```

As expected error bandwidth gets smaller as `k` increases.
Note that as `n` increases the estimated value tends to `1-exp(-1)`.

</details>
