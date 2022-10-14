# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 11

# Problems

### Exercise 1

Generate a data frame `df` having one column `x` consisting of 100,000 values
sampled from uniform distribution on [0, 1[ interval.
Serialize it to disk, and next deserialize. Check if the deserialized
object is the same as the source data frame.

<details>
<summary>Solution</summary>

```
julia> using DataFrames

julia> df = DataFrame(x=rand(100_000));

julia> using Serialization

julia> serialize("df.bin", df)

julia> deserialize("df.bin") == df
true
```

</details>

### Exercise 2

Add a column `n` to the `df` data frame that in each row will hold the
number of observations in column `x` that have distance less than `0.1` to
a value stored in a given row of `x`.

<details>
<summary>Solution</summary>

A simple approach is:
```
df.n = map(v -> count(abs.(df.x .- v) .< 0.1), df.x)
```

A more sophisticated approach (faster and allocating less memory) would be:
```
df.n = `map(v -> count(w -> abs(w-v) < 0.1, df.x), df.x)`
```

An even faster solution that is type stable would use function barrier:
```
f(x) = map(v -> count(w -> abs(w-v) < 0.1, x), x)
df.n = f(df.x)
```

Finally you can work on sorted data to get a much better performance. Here is an
example (it is a bit more advanced):
```
function f2(x)
    p = sortperm(x)
    n = zeros(Int, length(x))
    start = 1
    stop = 1
    idx = 0
    while idx < length(x) # you could add @inbounds here but I typically avoid it
        idx += 1
        while x[p[idx]] - x[p[start]] >= 0.1
            start += 1
        end
        while stop <= length(x) && x[p[stop]] - x[p[idx]] < 0.1
            stop += 1
        end
        n[p[idx]] = stop - start
    end
    return n
end
df.n = f2(df.x)
```

In this solution the fact that we used function barrier is even more relevant
as we explicitly use loops inside.

</details>

### Exercise 3

Investigate visually how does `n` depend on `x` in data frame `df`.

<details>
<summary>Solution</summary>

```
using Plots
scatter(df.x, df.n, xlabel="x", ylabel="neighbors", legend=false)
```

As expected on the border of the domain number of neighbors drops.

</details>

### Exercise 4

Someone has prepared the following test data for you:
```
teststr = """
"x","sinx"
0.139279,0.138829
0.456779,0.441059
0.344034,0.337287
0.140253,0.139794
0.848344,0.750186
0.977512,0.829109
0.032737,0.032731
0.702750,0.646318
0.422339,0.409895
0.393878,0.383772
"""
```

Load this data into `testdf` data frame.

<details>
<summary>Solution</summary>

```
julia> using CSV

julia> using DataFrames

julia> testdf = CSV.read(IOBuffer(teststr), DataFrame)
10×2 DataFrame
 Row │ x         sinx
     │ Float64   Float64
─────┼────────────────────
   1 │ 0.139279  0.138829
   2 │ 0.456779  0.441059
   3 │ 0.344034  0.337287
   4 │ 0.140253  0.139794
   5 │ 0.848344  0.750186
   6 │ 0.977512  0.829109
   7 │ 0.032737  0.032731
   8 │ 0.70275   0.646318
   9 │ 0.422339  0.409895
  10 │ 0.393878  0.383772
```

</details>

### Exercise 5

Check the accuracy of computations of sinus of `x` in `testdf`.
Print all rows for which the absolute difference is greater than `5e-7`.
In this case display `x`, `sinx`, the exact value of `sin(x)` and the absolute
difference.

<details>
<summary>Solution</summary>

Since data frame is small we can use `eachrow`:

```
julia> for row in eachrow(testdf)
           sinx = sin(row.x)
           dev = abs(sinx - row.sinx)
           dev > 5e-7 && println((x=row.x, computed=sinx, data=row.sinx, dev=dev))
       end
(x = 0.456779, computed = 0.44105962391808606, data = 0.441059, dev = 6.239180860845295e-7)
(x = 0.70275, computed = 0.6463185646550751, data = 0.646318, dev = 5.646550751414736e-7)
```

</details>

### Exercise 6

Group data in data frame `df` into buckets of 0.1 width and store the result in
`gdf` data frame (sort the groups). Use the `cut` function from
CategoricalArrays.jl to do it (check its documentation to learn how to do it).
Check the number of values in each group.

<details>
<summary>Solution</summary>

```
julia> using CategoricalArrays

julia> df.xbins = cut(df.x, 0.0:0.1:1.0);

julia> gdf = groupby(df, :xbins; sort=true);

julia> [nrow(group) for group in gdf]
10-element Vector{Int64}:
  9872
  9976
  9968
  9943
 10063
 10173
  9977
 10076
  9908
 10044

julia> combine(gdf, nrow) # alternative way to do it
10×2 DataFrame
 Row │ xbins       nrow
     │ Cat…        Int64
─────┼───────────────────
   1 │ [0.0, 0.1)   9872
   2 │ [0.1, 0.2)   9976
   3 │ [0.2, 0.3)   9968
   4 │ [0.3, 0.4)   9943
   5 │ [0.4, 0.5)  10063
   6 │ [0.5, 0.6)  10173
   7 │ [0.6, 0.7)   9977
   8 │ [0.7, 0.8)  10076
   9 │ [0.8, 0.9)   9908
  10 │ [0.9, 1.0)  10044
```

You might get a bit different numbers but all should be around 10,000.

</details>

### Exercise 7

Display the grouping keys in `gdf` grouped data frame. Show them as named tuples.
Check what would be the group order if you asked not to sort them.

<details>
<summary>Solution</summary>

```
julia> NamedTuple.(keys(gdf))
10-element Vector{NamedTuple{(:xbins,), Tuple{CategoricalValue{String, UInt32}}}}:
 (xbins = "[0.0, 0.1)",)
 (xbins = "[0.1, 0.2)",)
 (xbins = "[0.2, 0.3)",)
 (xbins = "[0.3, 0.4)",)
 (xbins = "[0.4, 0.5)",)
 (xbins = "[0.5, 0.6)",)
 (xbins = "[0.6, 0.7)",)
 (xbins = "[0.7, 0.8)",)
 (xbins = "[0.8, 0.9)",)
 (xbins = "[0.9, 1.0)",)

julia> NamedTuple.(keys(groupby(df, :xbins; sort=false)))
10-element Vector{NamedTuple{(:xbins,), Tuple{CategoricalValue{String, UInt32}}}}:
 (xbins = "[0.4, 0.5)",)
 (xbins = "[0.9, 1.0)",)
 (xbins = "[0.8, 0.9)",)
 (xbins = "[0.0, 0.1)",)
 (xbins = "[0.2, 0.3)",)
 (xbins = "[0.5, 0.6)",)
 (xbins = "[0.7, 0.8)",)
 (xbins = "[0.3, 0.4)",)
 (xbins = "[0.1, 0.2)",)
 (xbins = "[0.6, 0.7)",)
```

If you pass `sort=false` instead of `sort=true` you get groups in their order
of appearance in `df`. If you skipped specifying `sort` keyword argument
the resulting group order could depend on the type of grouping column, so if
you want to depend on the order of groups always spass `sort` keyword argument
explicitly.

</details>

### Exercise 8

Compute average `n` for each group in `gdf`.

<details>
<summary>Solution</summary>

```
julia> using Statistics

julia> [mean(group.n) for group in gdf]
10-element Vector{Float64}:
 14845.847751215559
 19835.367882919007
 19919.195826645264
 19993.023936437694
 20105.506111497565
 20222.35761329008
 20151.794727874112
 20022.69610956729
 19909.331550262414
 14944.511449621665

julia> combine(gdf, :n => mean) # alternative way to do it
10×2 DataFrame
 Row │ xbins       n_mean
     │ Cat…        Float64
─────┼─────────────────────
   1 │ [0.0, 0.1)  14845.8
   2 │ [0.1, 0.2)  19835.4
   3 │ [0.2, 0.3)  19919.2
   4 │ [0.3, 0.4)  19993.0
   5 │ [0.4, 0.5)  20105.5
   6 │ [0.5, 0.6)  20222.4
   7 │ [0.6, 0.7)  20151.8
   8 │ [0.7, 0.8)  20022.7
   9 │ [0.8, 0.9)  19909.3
  10 │ [0.9, 1.0)  14944.5
```

</details>

### Exercise 9

Fit a linear model explaining `n` by `x` separately for each group in `gdf`.
Use the `\` operator to fit it (recall it from chapter 4).
For each group produce the result as named tuple having fields `α₀` and `αₓ`.

<details>
<summary>Solution</summary>

```
julia> function fitmodel(x, n)
           X = [ones(length(x)) x]
           α₀, αₓ = X \ n
           return (α₀=α₀, αₓ=αₓ) # or (;α₀, αₓ) as will be discussed in chapter 14
       end
fitmodel (generic function with 1 method)

julia> [fitmodel(group.x, group.n) for group in gdf]
10-element Vector{NamedTuple{(:α₀, :αₓ), Tuple{Float64, Float64}}}:
 (α₀ = 9900.190310776916, αₓ = 99131.14394200995)
 (α₀ = 19823.115188829383, αₓ = 81.66979172871368)
 (α₀ = 19812.9822724435, αₓ = 424.00895772216785)
 (α₀ = 19810.726510910834, αₓ = 520.6763238983195)
 (α₀ = 19437.772385484135, αₓ = 1483.333906139938)
 (α₀ = 20187.521449870146, αₓ = 63.30709585406235)
 (α₀ = 20424.362332155855, αₓ = -419.42268710601405)
 (α₀ = 20789.70660364678, αₓ = -1022.9778397184706)
 (α₀ = 20013.690535193662, αₓ = -122.80055110522495)
 (α₀ = 109320.55276082881, αₓ = -99305.18846102979)

julia> combine(gdf, [:x, :n] => fitmodel => AsTable) # alternative syntax that you will learn in chapter 14
10×3 DataFrame
 Row │ xbins       α₀             αₓ
     │ Cat…        Float64        Float64
─────┼────────────────────────────────────────
   1 │ [0.0, 0.1)   9900.19        99131.1
   2 │ [0.1, 0.2)  19823.1            81.6698
   3 │ [0.2, 0.3)  19813.0           424.009
   4 │ [0.3, 0.4)  19810.7           520.676
   5 │ [0.4, 0.5)  19437.8          1483.33
   6 │ [0.5, 0.6)  20187.5            63.3071
   7 │ [0.6, 0.7)  20424.4          -419.423
   8 │ [0.7, 0.8)  20789.7         -1022.98
   9 │ [0.8, 0.9)  20013.7          -122.801
  10 │ [0.9, 1.0)      1.09321e5  -99305.2
```

We note that indeed in the first and last group the regression has a significant
slope.

</details>

### Exercise 10

Repeat exercise 9 but using the GLM.jl package. This time
extract the p-value for the slope of estimated coefficient for `x` variable.
Use the `coeftable` function from GLM.jl to get this information.
Check the documentation of this function to learn how to do it (it will be
easiest for you to first convert its result to a `DataFrame`).

<details>
<summary>Solution</summary>

```
julia> using GLM

julia> function fitlmmodel(group; info=false)
           model = lm(@formula(n~x), group)
           coefdf = DataFrame(coeftable(model))
           info && @show coefdf # to see how the data frame looks like
           α₀, αₓ = coefdf[:, "Coef."]
           return (α₀=α₀, αₓ=αₓ) # or (;α₀, αₓ) as will be discussed in chapter 14
       end
fitlmmodel (generic function with 1 method)

julia> [fitlmmodel(group; info = true) for group in gdf]
coefdf = 2×7 DataFrame
 Row │ Name         Coef.     Std. Error  t        Pr(>|t|)  Lower 95%  Upper 95%
     │ String       Float64   Float64     Float64  Float64   Float64    Float64
─────┼────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)   9900.19    0.388607  25476.1       0.0    9899.43    9900.95
   2 │ x            99131.1     6.75846   14667.7       0.0   99117.9    99144.4
coefdf = 2×7 DataFrame
 Row │ Name         Coef.       Std. Error  t           Pr(>|t|)    Lower 95%  Upper 95%
     │ String       Float64     Float64     Float64     Float64     Float64    Float64
─────┼───────────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)  19823.1        2.52926  7837.5      0.0         19818.2    19828.1
   2 │ x               81.6698    16.5512      4.93436  8.17139e-7     49.226    114.114
coefdf = 2×7 DataFrame
 Row │ Name         Coef.      Std. Error  t          Pr(>|t|)      Lower 95%  Upper 95%
     │ String       Float64    Float64     Float64    Float64       Float64    Float64
─────┼───────────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)  19813.0        2.8427  6969.79    0.0            19807.4   19818.6
   2 │ x              424.009     11.2737    37.6106  1.32368e-289     401.91    446.108
coefdf = 2×7 DataFrame
 Row │ Name         Coef.      Std. Error  t          Pr(>|t|)  Lower 95%  Upper 95%
     │ String       Float64    Float64     Float64    Float64   Float64    Float64
─────┼───────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)  19810.7       3.98478  4971.59         0.0  19802.9    19818.5
   2 │ x              520.676    11.3429     45.9033       0.0    498.442    542.911
coefdf = 2×7 DataFrame
 Row │ Name         Coef.     Std. Error  t         Pr(>|t|)  Lower 95%  Upper 95%
     │ String       Float64   Float64     Float64   Float64   Float64    Float64
─────┼─────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)  19437.8      6.07925  3197.4         0.0   19425.9    19449.7
   2 │ x             1483.33    13.4768    110.065       0.0    1456.92    1509.75
coefdf = 2×7 DataFrame
 Row │ Name         Coef.       Std. Error  t           Pr(>|t|)     Lower 95%   Upper 95%
     │ String       Float64     Float64     Float64     Float64      Float64     Float64
─────┼─────────────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)  20187.5        9.72795  2075.21     0.0          20168.5     20206.6
   2 │ x               63.3071    17.6538      3.58603  0.000337323     28.7022     97.912
coefdf = 2×7 DataFrame
 Row │ Name         Coef.      Std. Error  t          Pr(>|t|)     Lower 95%  Upper 95%
     │ String       Float64    Float64     Float64    Float64      Float64    Float64
─────┼──────────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)  20424.4       10.2201  1998.45    0.0           20404.3   20444.4
   2 │ x             -419.423     15.7112   -26.6958  1.0356e-151    -450.22   -388.626
coefdf = 2×7 DataFrame
 Row │ Name         Coef.     Std. Error  t          Pr(>|t|)  Lower 95%  Upper 95%
     │ String       Float64   Float64     Float64    Float64   Float64    Float64
─────┼──────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)  20789.7      9.56063  2174.51         0.0   20771.0   20808.4
   2 │ x            -1022.98    12.7417    -80.2856       0.0   -1047.95   -998.001
coefdf = 2×7 DataFrame
 Row │ Name         Coef.      Std. Error  t         Pr(>|t|)     Lower 95%  Upper 95%
     │ String       Float64    Float64     Float64   Float64      Float64    Float64
─────┼─────────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)  20013.7       8.86033  2258.8    0.0          19996.3    20031.1
   2 │ x             -122.801    10.4201    -11.785  7.60822e-32   -143.226   -102.375
coefdf = 2×7 DataFrame
 Row │ Name         Coef.           Std. Error  t         Pr(>|t|)  Lower 95%       Upper 95%
     │ String       Float64         Float64     Float64   Float64   Float64         Float64
─────┼─────────────────────────────────────────────────────────────────────────────────────────────
   1 │ (Intercept)       1.09321e5     5.78343   18902.4       0.0       1.09309e5       1.09332e5
   2 │ x            -99305.2           6.08269  -16325.9       0.0  -99317.1        -99293.3
10-element Vector{NamedTuple{(:α₀, :αₓ), Tuple{Float64, Float64}}}:
 (α₀ = 9900.190310776927, αₓ = 99131.1439420097)
 (α₀ = 19823.115188829663, αₓ = 81.66979172690417)
 (α₀ = 19812.98227244386, αₓ = 424.00895772074136)
 (α₀ = 19810.726510911398, αₓ = 520.6763238966264)
 (α₀ = 19437.772385487086, αₓ = 1483.3339061333743)
 (α₀ = 20187.521449871012, αₓ = 63.307095852511125)
 (α₀ = 20424.36233216108, αₓ = -419.4226871140539)
 (α₀ = 20789.706603652226, αₓ = -1022.9778397257375)
 (α₀ = 20013.69053519897, αₓ = -122.80055111148658)
 (α₀ = 109320.55276074051, αₓ = -99305.18846093686)

julia> combine(gdf, fitlmmodel)
10×3 DataFrame
 Row │ xbins       α₀             αₓ
     │ Cat…        Float64        Float64
─────┼────────────────────────────────────────
   1 │ [0.0, 0.1)   9900.19        99131.1
   2 │ [0.1, 0.2)  19823.1            81.6698
   3 │ [0.2, 0.3)  19813.0           424.009
   4 │ [0.3, 0.4)  19810.7           520.676
   5 │ [0.4, 0.5)  19437.8          1483.33
   6 │ [0.5, 0.6)  20187.5            63.3071
   7 │ [0.6, 0.7)  20424.4          -419.423
   8 │ [0.7, 0.8)  20789.7         -1022.98
   9 │ [0.8, 0.9)  20013.7          -122.801
  10 │ [0.9, 1.0)      1.09321e5  -99305.2
```

We got the same results. The `combine(gdf, fitlmmodel)` style of using
the `combine` function is a bit more advanced and is not covered in the book.
It is used in the cases, like the one we have here, when you want to pass
a whole group to the function in `combine`. Check DataFrames.jl documentation
for more detailed explanations.

</details>
