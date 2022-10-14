# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 6

# Problems

### Exercise 1

Interpolate the expression `1 + 2` into a string `"I have apples worth 3USD"`
(replace `3` by a proper interpolation expression) and replace `USD` by `$`.

<details>
<summary>Solution</summary>

```
julia> "I have apples worth $(1+2)\$"
"I have apples worth 3\$"
```

</details>

### Exercise 2

Download the file `https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data`
as `iris.csv` to your local folder.

<details>
<summary>Solution</summary>

```
import Downloads
Downloads.download("https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data",
                   "iris.csv")
```

</details>

### Exercise 3

Write the string `"https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"`
in two lines so that it takes less horizontal space.

<details>
<summary>Solution</summary>

```
"https://archive.ics.uci.edu/ml/\
 machine-learning-databases/iris/iris.data"
```

</details>

### Exercise 4

Load data stored in `iris.csv` file into a `data` vector where each element
should be a named tuple of the form `(sl=1.0, sw=2.0, pl=3.0, pw=4.0, c="x")` if
the source line had data `1.0,2.0,3.0,4.0,x` (note that first four elements are parsed
as floats).

<details>
<summary>Solution</summary>

```
julia> function line_parser(line)
           elements = split(line, ",")
           @assert length(elements) == 5
           return (sl=parse(Float64, elements[1]),
                   sw=parse(Float64, elements[2]),
                   pl=parse(Float64, elements[3]),
                   pw=parse(Float64, elements[4]),
                   c=elements[5])
       end
line_parser (generic function with 1 method)

julia> data = line_parser.(readlines("iris.csv")[1:end-1])
150-element Vector{NamedTuple{(:sl, :sw, :pl, :pw, :c), Tuple{Float64, Float64, Float64, Float64, SubString{String}}}}:
 (sl = 5.1, sw = 3.5, pl = 1.4, pw = 0.2, c = "Iris-setosa")
 (sl = 4.9, sw = 3.0, pl = 1.4, pw = 0.2, c = "Iris-setosa")
 (sl = 4.7, sw = 3.2, pl = 1.3, pw = 0.2, c = "Iris-setosa")
 (sl = 4.6, sw = 3.1, pl = 1.5, pw = 0.2, c = "Iris-setosa")
 (sl = 5.0, sw = 3.6, pl = 1.4, pw = 0.2, c = "Iris-setosa")
 ⋮
 (sl = 6.3, sw = 2.5, pl = 5.0, pw = 1.9, c = "Iris-virginica")
 (sl = 6.5, sw = 3.0, pl = 5.2, pw = 2.0, c = "Iris-virginica")
 (sl = 6.2, sw = 3.4, pl = 5.4, pw = 2.3, c = "Iris-virginica")
 (sl = 5.9, sw = 3.0, pl = 5.1, pw = 1.8, c = "Iris-virginica")
```

Note that we used `1:end-1` selector to drop last element from the read lines
since it is empty. This is the reason why adding the
`@assert length(elements) == 5` check in the `line_parser` function is useful.

</details>

### Exercise 5

The `data` structure is a vector of named tuples, change it to a named tuple
of vectors (with the same field names) and call it `data2`.

<details>
<summary>Solution</summary>

Later in the book you will learn more advanced ways to do it. Here let us
use a most basic approach:

```
data2 = (sl=[d.sl for d in data],
         sw=[d.sw for d in data],
         pl=[d.pl for d in data],
         pw=[d.pw for d in data],
         c=[d.c for d in data])
```

</details>

### Exercise 6

Calculate the frequency of each type of Iris type (`c` field in `data2`).

<details>
<summary>Solution</summary>

```
julia> using FreqTables

julia> freqtable(data2.c)
3-element Named Vector{Int64}
Dim1              │
──────────────────┼───
"Iris-setosa"     │ 50
"Iris-versicolor" │ 50
"Iris-virginica"  │ 50
```

</details>

### Exercise 7

Create a vector `c2` that is derived from `c` in `data2` but holds inline strings,
vector `c3` that is a `PooledVector`, and vector `c4` that holds `Symbol`s.
Compare sizes of the three objects.

<details>
<summary>Solution</summary>

```
julia> using InlineStrings

julia> c2 = inlinestrings(data2.c)
150-element Vector{String15}:
 "Iris-setosa"
 "Iris-setosa"
 "Iris-setosa"
 "Iris-setosa"
 "Iris-setosa"
 ⋮
 "Iris-virginica"
 "Iris-virginica"
 "Iris-virginica"
 "Iris-virginica"

julia> using PooledArrays

julia> c3 = PooledArray(data2.c)
150-element PooledVector{SubString{String}, UInt32, Vector{UInt32}}:
 "Iris-setosa"
 "Iris-setosa"
 "Iris-setosa"
 "Iris-setosa"
 "Iris-setosa"
 ⋮
 "Iris-virginica"
 "Iris-virginica"
 "Iris-virginica"
 "Iris-virginica"

julia> c4 = Symbol.(data2.c)
150-element Vector{Symbol}:
 Symbol("Iris-setosa")
 Symbol("Iris-setosa")
 Symbol("Iris-setosa")
 Symbol("Iris-setosa")
 Symbol("Iris-setosa")
 ⋮
 Symbol("Iris-virginica")
 Symbol("Iris-virginica")
 Symbol("Iris-virginica")
 Symbol("Iris-virginica")

julia> Base.summarysize(data2.c)
12840

julia> Base.summarysize(c2)
2440

julia> Base.summarysize(c3)
1696

julia> Base.summarysize(c4)
1240
```

</details>

### Exercise 8

You know that `refs` field of `PooledArray` stores an integer index of a given
value in it. Using this information make a scatter plot of `pl` vs `pw` vectors
in `data2`, but for each Iris type give a different point color (check the
`color` keyword argument meaning in the Plots.jl manual; you can use the
`plot_color` function).

<details>
<summary>Solution</summary>

```
using Plots
scatter(data2.pl, data2.pw, color=plot_color(c3.refs), legend=false)
```

</details>

### Exercise 9

Type the following string `"a²=b² ⟺ a=b ∨ a=-b"` in your terminal and bind it to
`str` variable (do not copy paste the string, but type it).

<details>
<summary>Solution</summary>

The hard part is typing `²`, `⟺` and `∨`. You can check how to do it using help:
```
help?> ²
"²" can be typed by \^2<tab>

help?> ⟺
"⟺" can be typed by \iff<tab>

help?> ∨
"∨" can be typed by \vee<tab>
```

Save the string in the `str` variable as we will use it in the next exercise.

</details>

### Exercise 10

In the `str` string from exercise 9 find all matches of a pattern where `a`
is followed by `b` but there can be some characters between them.

<details>
<summary>Show!</summary>

The exercise does not specify how the matching should be done. If we
want it to be eager (match as much as possible), we write:

```
julia> m = match(r"a.*b", str)
RegexMatch("a²=b² ⟺ a=b ∨ a=-b")
```

As you can see we have matched whole string.

If we want it to be lazy (match as little as possible) we write:

```
julia> m = match(r"a.*?b", str)
RegexMatch("a²=b")
```

This finds us the first such match.

If we want to find all lazy matches we can write (not covered in the book):

```
julia> collect(eachmatch(r"a.*?b", str))
3-element Vector{RegexMatch}:
 RegexMatch("a²=b")
 RegexMatch("a=b")
 RegexMatch("a=-b")
```

</details>
