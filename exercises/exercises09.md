# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 9

# Problems

In this problemset we will use the `puzzles.csv` file that was
created in chapter 8. Please first load it into your Julia
session using the commands:

```
using CSV
using DataFrames
puzzles = CSV.read("puzzles.csv", DataFrame);
```

### Exercise 1

Create `matein2` data frame that will have only puzzles that have `"mateIn2"`
in the `Themes` column.
Use the `contains` function (check its documentation first).

<details>
<summary>Solution</summary>

```
julia> matein2 = puzzles[contains.(puzzles.Themes, "mateIn2"), :]
274135×9 DataFrame
    Row │ PuzzleId  FEN                                Moves                Rating  RatingDeviation  Popularity  NbPlays  Themes                             GameUrl    ⋯
        │ String7   String                             String               Int64   Int64            Int64       Int64    String                             String     ⋯
────────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
      1 │ 000hf     r1bqk2r/pp1nbNp1/2p1p2p/8/2BP4/1…  e8f7 e2e6 f7f8 e6f7    1560               76          88      441  mate mateIn2 middlegame short      https://li ⋯
      2 │ 001Wz     4r1k1/5ppp/r1p5/p1n1RP2/8/2P2N1P…  e8e5 d1d8 e5e8 d8e8    1128               81          87       54  backRankMate endgame mate mateIn…  https://li
      3 │ 001om     5r1k/pp4pp/5p2/1BbQp1r1/6K1/7P/1…  g4h4 c5f2 g2g3 f2g3     991               78          89      215  mate mateIn2 middlegame short      https://li
      4 │ 003Tx     2r5/pR5p/5p1k/4p3/4r3/B4nPP/PP3P…  e1e4 f3d2 b1a1 c8c1    1716               77          87      476  backRankMate endgame fork mate m…  https://li
   ⋮    │    ⋮                      ⋮                           ⋮             ⋮            ⋮             ⋮          ⋮                     ⋮                             ⋱
 274132 │ zzxQS     2R2q2/3nk1r1/p1Br1p2/1p2p3/1P3Pn…  c8f8 d6d1 e3e1 d1e1    1149               75          96     1722  mate mateIn2 middlegame short      https://li ⋯
 274133 │ zzxvB     5rk1/R1Q2ppp/5n2/4p3/1pB5/7q/1P3…  f6g4 c7f7 f8f7 a7a8    1695               74          95     4857  endgame mate mateIn2 pin sacrifi…  https://li
 274134 │ zzzRN     4r2k/1NR2Q1p/4P1n1/pp1p4/3P4/4q3…  g1h1 e3e1 f7f1 e1f1     830              108          67       31  endgame mate mateIn2 short         https://li
 274135 │ zzzco     5Q2/pp3R1P/1kpp4/4p3/2P1P3/3PP2P…  f7f2 b2c2 c1b1 e2d1    1783               75          90      763  endgame mate mateIn2 queensideAt…  https://li
                                                                                                                                         1 column and 274127 rows omitted
```

</details>

### Exercise 2

What is the fraction of puzzles that are mate in 2 in relation to all puzzles
in the `puzzles` data frame?

<details>
<summary>Solution</summary>

Two ways to do it:

```
julia> using Statistics

julia> nrow(matein2) / nrow(puzzles)
0.12852152542746353

julia> mean(contains.(puzzles.Themes, "mateIn2"))
0.12852152542746353
```

</details>

### Exercise 3

Create `small` data frame that holds first 10 rows of `matein2` data frame
and columns `Rating`, `RatingDeviation`, and `NbPlays`.

<details>
<summary>Solution</summary>

```
julia> small = matein2[1:10, ["Rating", "RatingDeviation", "NbPlays"]]
10×3 DataFrame
 Row │ Rating  RatingDeviation  NbPlays
     │ Int64   Int64            Int64
─────┼──────────────────────────────────
   1 │   1560               76      441
   2 │   1128               81       54
   3 │    991               78      215
   4 │   1716               77      476
   5 │    711               81      111
   6 │    723               86      806
   7 │    754               92      248
   8 │   1177               76      827
   9 │    994               81       71
  10 │    979              144       14
```

</details>

### Exercise 4

Iterate rows of `small` data frame and print the ratio of
`RatingDeviation` and `NbPlays` for each row.

<details>
<summary>Solution</summary>

```
julia> for row in eachrow(small)
           println(row.RatingDeviation / row.NbPlays)
       end
0.17233560090702948
1.5
0.3627906976744186
0.16176470588235295
0.7297297297297297
0.10669975186104218
0.3709677419354839
0.09189842805320435
1.1408450704225352
10.285714285714286
```

</details>

### Exercise 5

Get names of columns from the `matein2` data frame that end with `n` (ignore case).

<details>
<summary>Solution</summary>

Several options:
```
julia> names(matein2, Cols(col -> uppercase(col[end]) == 'N'))
2-element Vector{String}:
 "FEN"
 "RatingDeviation"

julia> names(matein2, Cols(col -> endswith(uppercase(col), "N")))
2-element Vector{String}:
 "FEN"
 "RatingDeviation"

julia> names(matein2, r"[nN]$")
2-element Vector{String}:
 "FEN"
 "RatingDeviation"
```

</details>

### Exercise 6

Write a function `collatz` that runs the following process. Start with a
positive number `n`. If it is even divide it by two. If it is odd multiply
it by 3 and add one. The function should return the number of steps needed to
reach 1.

Create a `d` dictionary that maps number of steps needed to a list of numbers from
the range `1:100` that required this number of steps.

<details>
<summary>Solution</summary>

```
julia> function collatz(n)
           i = 0
           while n != 1
               i += 1
               n = iseven(n) ? div(n, 2) : 3 * n + 1
           end
           return i
       end
collatz (generic function with 1 method)

julia> d = Dict{Int, Vector{Int}}()
Dict{Int64, Vector{Int64}}()

julia> for n in 1:100
           i = collatz(n)
           if haskey(d, i)
               push!(d[i], n)
           else
               d[i] = [n]
           end
       end

julia> d
Dict{Int64, Vector{Int64}} with 45 entries:
  5   => [5, 32]
  35  => [78, 79]
  110 => [82, 83]
  30  => [86, 87, 89]
  32  => [57, 59]
  6   => [10, 64]
  115 => [73]
  112 => [54, 55]
  4   => [16]
  13  => [34, 35]
  104 => [47]
  12  => [17, 96]
  23  => [25]
  111 => [27]
  92  => [91]
  11  => [48, 52, 53]
  118 => [97]
  ⋮   => ⋮
```

As we can see even for small `n` the number of steps required to reach `1`
can get quite large.

</details>

### Exercise 7

Using the `d` dictionary make a scatter plot of number of steps required
vs average value of numbers that require this number of steps.

<details>
<summary>Solution</summary>

```
using Plots
using Statistics
steps = collect(keys(d))
mean_number = mean.(values(d))
scatter(steps, mean_number, xlabel="steps", ylabel="mean of numbers", legend=false)
```

Note that we needed to use `collect` on `keys` as `scatter` expects an array
not just an iterator.

</details>

### Exercise 8

Repeat the process from exercises 6 and 7, but this time use a data frame
and try to write an appropriate expression using the `combine` and `groupby`
functions (as it was explained in the last part of chapter 9). This time
perform computations for numbers ranging from one to one million.

<details>
<summary>Solution</summary>

```
df = DataFrame(n=1:10^6);
df.collatz = collatz.(df.n);
agg = combine(groupby(df, :collatz), :n => mean);
scatter(agg.collatz, agg.n_mean, xlabel="steps", ylabel="mean of numbers", legend=false)
```

</details>

### Exercise 9

Set seed of random number generator to `1234`. Draw 100 random points
from the interval `[0, 1]`. Store this vector in a data frame as `x` column.
Now compute `y` column using a formula `4 * (x - 0.5) ^ 2`.
Add random noise to column `y` that has normal distribution with mean 0 and
standard deviation 0.25. Call this column `z`.
Make a scatter plot with `x` on x-axis and `y` and `z` on y-axis.

<details>
<summary>Solution</summary>

```
using Random
Random.seed!(1234)
df = DataFrame(x=rand(100))
df.y = 4 .* (df.x .- 0.5) .^ 2
df.z = df.y + randn(100) / 4
scatter(df.x, [df.y df.z], labels=["y" "z"])
```

</details>

### Exercise 10

Add a line of LOESS regression of `x` explaining `z` plot to figure produced in exercise 10.

<details>
<summary>Solution</summary>

```
using Loess
model = loess(df.x, df.z);
x_predict = sort(df.x)
z_predict = predict(model, x_predict)
plot!(x_predict, z_predict; label="z predicted")
```

</details>
