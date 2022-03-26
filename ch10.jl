# Bogumił Kamiński, 2022

# Codes for chapter 10

# Code for section 10.1

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
       5.0   5.68   5.0  4.74   5.0   5.73   8.0   6.89];

using DataFrames

# Code for listing 10.1

aq1 = DataFrame(aq, ["x1", "y1", "x2", "y2", "x3", "y3", "x4", "y4"])
DataFrame(aq, [:x1, :y1, :x2, :y2, :x3, :y3, :x4, :y4])

# Code for creating DataFrame with automatic column names

DataFrame(aq, :auto)

# Codes for creating DataFrame from vector of vectors

aq_vec = collect(eachcol(aq))
DataFrame(aq_vec, ["x1", "y1", "x2", "y2", "x3", "y3", "x4", "y4"])
DataFrame(aq_vec, :auto)

# Codes for section 10.1.2

data = (set1=(x=aq[:, 1], y=aq[:, 2]),
        set2=(x=aq[:, 3], y=aq[:, 4]),
        set3=(x=aq[:, 5], y=aq[:, 6]),
        set4=(x=aq[:, 7], y=aq[:, 8]));

data.set1.x

DataFrame(x1=data.set1.x, y1=data.set1.y,
          x2=data.set2.x, y2=data.set2.y,
          x3=data.set3.x, y3=data.set3.y,
          x4=data.set4.x, y4=data.set4.y)

DataFrame(:x1 => data.set1.x, :y1 => data.set1.y,
          :x2 => data.set2.x, :y2 => data.set2.y,
          :x3 => data.set3.x, :y3 => data.set3.y,
          :x4 => data.set4.x, :y4 => data.set4.y)

DataFrame([:x1 => data.set1.x, :y1 => data.set1.y,
           :x2 => data.set2.x, :y2 => data.set2.y,
           :x3 => data.set3.x, :y3 => data.set3.y,
           :x4 => data.set4.x, :y4 => data.set4.y]);

[(i, v) for i in 1:4 for v in [:x, :y]]

[string(v, i) for i in 1:4 for v in [:x, :y]]

[string(v, i) => getproperty(data[i], v)
        for i in 1:4 for v in [:x, :y]]

DataFrame([string(v, i) => getproperty(data[i], v)
           for i in 1:4 for v in [:x, :y]]);

data_dict = Dict([string(v, i) => getproperty(data[i], v)
                         for i in 1:4 for v in [:x, :y]])
collect(data_dict)

DataFrame(data_dict)

df1 = DataFrame(x1=data.set1.x)
df1.x1 === data.set1.x

df2 = DataFrame(x1=data.set1.x; copycols=false)
df2.x1 === data.set1.x

df = DataFrame(x=1:3, y=1)
df.x

DataFrame(x=[1], y=[1, 2, 3])

using RCall
r_df = R"data.frame(a=1:6, b=1:2, c=1:3)"
julia_df = rcopy(r_df)

# Codes for section 10.1.3

data.set1
DataFrame(data.set1)

DataFrame([(a=1, b=2), (a=3, b=4), (a=5, b=6)])

data

# Code for listing 10.2

aq2 = DataFrame(data)

# Codes for listing 10.3

data_dfs = map(DataFrame, data)

# Codes for vertical concatenation examples

vcat(data_dfs.set1, data_dfs.set2, data_dfs.set3, data_dfs.set4)

vcat(data_dfs.set1, data_dfs.set2, data_dfs.set3, data_dfs.set4;
     source="source_id")

vcat(data_dfs.set1, data_dfs.set2, data_dfs.set3, data_dfs.set4;
     source="source_id"=>string.("set", 1:4))

reduce(vcat, collect(data_dfs);
       source="source_id"=>string.("set", 1:4))

# Code for listing 10.4

df1 = DataFrame(a=1:3, b=11:13)
df2 = DataFrame(a=4:6, c=24:26)
vcat(df1, df2)
vcat(df1, df2; cols=:union)

# Code for listing 10.5

df_agg = DataFrame()
append!(df_agg, data_dfs.set1)
append!(df_agg, data_dfs.set2)

# Code for appending tables to a data frame

df_agg = DataFrame()
append!(df_agg, data.set1)
append!(df_agg, data.set2)

# Code for promote keyword argument

df1 = DataFrame(a=1:3, b=11:13)
df2 = DataFrame(a=4:6, b=[14, missing, 16])
append!(df1, df2)
append!(df1, df2; promote=true)

# Code for section 10.2.3

df = DataFrame()
push!(df, (a=1, b=2))
push!(df, (a=3, b=4))

df = DataFrame(a=Int[], b=Int[])
push!(df, [1, 2])
push!(df, [3, 4])

function sim_step(current)
    dx, dy = rand(((1,0), (-1,0), (0,1), (0,-1)))
    return (x=current.x + dx, y=current.y + dy)
end

using BenchmarkTools
@btime rand(((1,0), (-1,0), (0,1), (0,-1)));

dx, dy = (10, 20)
dx
dy

using FreqTables
using Random
Random.seed!(1234);
proptable([rand(((1,0), (-1,0), (0,1), (0,-1))) for _ in 1:10^7])

using Random
Random.seed!(6);
walk = DataFrame(x=0, y=0)
for _ in 1:10
    current = walk[end, :]
    push!(walk, sim_step(current))
end
walk

using Plots
plot(walk.x, walk.y;
     legend=false,
     series_annotations=1:11,
     xticks=range(extrema(walk.x)...),
     yticks=range(extrema(walk.y)...))

extrema(walk.y)

range(1, 5)

(3/4)^9

# Code for listing 10.6

function walk_unique() #A
    walk = DataFrame(x=0, y=0)
    for _ in 1:10
        current = walk[end, :]
        push!(walk, sim_step(current))
    end
    return nrow(unique(walk)) == nrow(walk) #B
end
Random.seed!(2);
proptable([walk_unique() for _ in 1:10^5])

# code for serialization

using Serialization
serialize("walk.bin", walk)
deserialize("walk.bin") == walk
