# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 12

# Problems

### Exercise 1

The https://go.dev/dl/go1.19.2.src.tar.gz link contains source code of
Go language version 19.2. As you can check on its website its SHA-256
is `sha = "2ce930d70a931de660fdaf271d70192793b1b240272645bf0275779f6704df6b"`.
Download this file and check if it indeed has this checksum.
You might need to read documentation of `string` and `join` functions.

<details>
<summary>Solution</summary>

```
using Downloads
using SHA
Downloads.download("https://go.dev/dl/go1.19.2.src.tar.gz", "go.tar.gz")
shavec = open(sha256, "go.tar.gz")
shastr = join(string.(shavec; base=16, pad=2))
sha == shastr
```

The last line should produce `true`.

</details>

### Exercise 2

Download the file http://snap.stanford.edu/data/deezer_ego_nets.zip
that contains the ego-nets of Eastern European users collected from the music
streaming service Deezer in February 2020. Nodes are users and edges are mutual
follower relationships.

From the file extract deezer_edges.json and deezer_target.csv files and
save them to disk.

<details>
<summary>Solution</summary>

```
Downloads.download("http://snap.stanford.edu/data/deezer_ego_nets.zip", "ego.zip")
import ZipFile
archive = ZipFile.Reader("ego.zip")
idx = only(findall(x -> contains(x.name, "deezer_edges.json"), archive.files))
open("deezer_edges.json", "w") do io
    write(io, read(archive.files[idx]))
end
idx = only(findall(x -> contains(x.name, "deezer_target.csv"), archive.files))
open("deezer_target.csv", "w") do io
    write(io, read(archive.files[idx]))
end
close(archive)
```

</details>

### Exercise 3

Load deezer_edges.json and deezer_target.csv files to Julia.
The JSON file should be loaded as JSON3.jl object `edges_json`.
The CSV file should be loaded into a data frame `target_df`.

<details>
<summary>Solution</summary>

```
using CSV
using DataFrames
using JSON3
edges_json = JSON3.read(read("deezer_edges.json"))
target_df = CSV.read("deezer_target.csv", DataFrame)
```

</details>

### Exercise 4

Check that keys in the `edges_json` are in the same order as `id` column
in `target_df`.

<details>
<summary>Solution</summary>

This is short, but you need to have a good understanding of Julia types
and standar functions to properly write it:
```
Symbol.(target_df.id) == collect(keys(edges_json))
```

</details>

### Exercise 5

From every value stored in `edges_json` create a graph representing
ego-net of the given node. Store these graphs in a vector that will make the
`egonet` column of in the `target_df` data frame.

<details>
<summary>Solution</summary>

```
using Graphs
function edgelist2graph(edgelist)
    nodes = sort!(unique(reduce(vcat, edgelist)))
    @assert 0:length(nodes)-1 == nodes
    g = SimpleGraph(length(nodes))
    for (a, b) in edgelist
        add_edge!(g, a+1, b+1)
    end
    return g
end
target_df.egonet = edgelist2graph.(values(edges_json))
```

</details>

### Exercise 6

Ego-net in our data set is a subgraph of a full Deezer graph where for some
node all its neighbors are included, but also it contains all edges between the
neighbors.
Therefore we expect that diameter of every ego-net is at most 2 (as every
two nodes are either connected directly or by a common friend).
Check if this is indeed the case. Use the `diameter` function.

<details>
<summary>Solution</summary>

```
julia> extrema(diameter.(target_df.egonet))
(2, 2)
```

Indeed we see that for each ego-net diameter is 2.

</details>

### Exercise 7

For each ego-net find a central node that is connected to every other node
in this network. Use the `degree` and `findall` functions to achieve this.
Add `center` column with numbers of nodes that are connected to all other
nodes in the ego-net to `target_df` data frame.

Next add a column `center_len` that gives the number of such nodes.

Check how many times different numbers of center nodes are found.

<details>
<summary>Solution</summary>

```
target_df.center = map(target_df.egonet) do g
    findall(==(nv(g) - 1), degree(g))
end
target_df.center_len = length.(target_df.center)
combine(groupby(target_df, :center_len, sort=true), nrow)
```

Note that we used `map` since in this case it gives a convenient way to express
the condition we want to check.

We notice that in some cases it is impossible to identify the center of the
ego-net uniquely.

</details>

### Exercise 8

Add the following ego-net features to the `target_df` data frame:
* `size`: number of nodes in ego-net
* `mean_degree`: average node degree in ego-net

Check mean values of these two columns by `target` column.

<details>
<summary>Solution</summary>

```
using Statistics
target_df.size = nv.(target_df.egonet)
target_df.mean_degree = 2 .* ne.(target_df.egonet) ./ target_df.size
combine(groupby(target_df, :target, sort=true), [:size, :mean_degree] .=> mean)
```

It seems that for target equal to `0` size and average degree in the network are
a bit larger.

</details>

### Exercise 9

Continuing to work with `target_df` data frame create a logistic regression
explaining `target` by `size` and `mean_degree`.

<details>
<summary>Solution</summary>

```
using GLM
glm(@formula(target~size+mean_degree), target_df, Binomial(), LogitLink())
```

We see that only `size` is statistically significant.

</details>

### Exercise 10

Continuing to work with `target_df` create a scatterplot where `size` will be on
one axis and `mean_degree` rounded to nearest integer on the other axis.
Plot the mean of `target` for each point being a combination of `size` and
rounded `mean_degree`.

Additionally fit a LOESS model explaining `target` by `size`. Make a prediction
for values in range from 5% to 95% quantile (to concentrate on typical values
of size).

<details>
<summary>Solution</summary>

```
using Plots
target_df.round_degree = round.(Int, target_df.mean_degree)
agg_df = combine(groupby(target_df, [:size, :round_degree]), :target => mean)
scatter(agg_df.size, agg_df.round_degree;
        zcolor=agg_df.target_mean,
        xlabel="size", ylabel="rounded degree",
        label="mean target", xaxis=:log)
```

It is hard to visually see any strong relationship in the data.

```
import Loess
model = Loess.loess(target_df.size, target_df.target)
size_predict = quantile(target_df.size, 0.05):1.0:quantile(target_df.size, 0.95)
target_predict = Loess.predict(model, size_predict)
plot(size_predict, target_predict;
     xlabel="size", ylabel="predicted target", legend=false)
```

Between quantiles 5% and 95% of `size` we see a downward shaped relationship.

</details>
