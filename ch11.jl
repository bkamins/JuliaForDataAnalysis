# Bogumił Kamiński, 2022

# Codes for chapter 11

# Code for section 11.1

# deserialization of source data frame

using DataFrames
using Serialization
walk = deserialize("walk.bin")

# Code for a note on conversion

x = [1.5]
x[1] = 1
x

# Code from section 11.1.1

Matrix(walk)
Matrix{Any}(walk)
Matrix{String}(walk)

plot(walk)

plot(Matrix(walk); labels=["x" "y"] , legend=:topleft)

# Code from section 11.1.2

Tables.columntable(walk)

using BenchmarkTools
function mysum(table)
           s = 0 #A
           for v in table.x #B
               s += v
           end
           return s
       end
df = DataFrame(x=1:1_000_000);
@btime mysum($df)

tab = Tables.columntable(df);
@btime mysum($tab)

@code_warntype mysum(df)

@code_warntype mysum(tab)

typeof(tab)

function barrier_mysum2(x)
    s = 0
    for v in x
        s += v
    end
    return s
end
mysum2(table) = barrier_mysum2(table.x)
@btime mysum2($df)

df = DataFrame(a=[1, 1, 2], b=[1, 1, 2])
unique(df)

tab = Tables.columntable(df)
unique(tab)

# Code from section 11.1.3

Tables.rowtable(walk)

nti = Tables.namedtupleiterator(walk)
for v in nti
    println(v)
end

er = eachrow(walk)
er[1]
er[end]
ec = eachcol(walk)
ec[1]
ec[end]

identity.(eachcol(walk))

df = DataFrame(x=1:2, b=["a", "b"])
identity.(eachcol(df))

# Code from section 11.2

using CSV
raw_data = """
city,date,rainfall
Olecko,2020-11-16,2.9
Olecko,2020-11-17,4.1
Olecko,2020-11-19,4.3
Olecko,2020-11-20,2.0
Olecko,2020-11-21,0.6
Olecko,2020-11-22,1.0
Ełk,2020-11-16,3.9
Ełk,2020-11-19,1.2
Ełk,2020-11-20,2.0
Ełk,2020-11-22,2.0
""";
rainfall_df = CSV.read(IOBuffer(raw_data), DataFrame)

gdf_city = groupby(rainfall_df, "city")

gdf_city_date = groupby(rainfall_df, Not("rainfall"))

keys(gdf_city_date)

gk1 = keys(gdf_city_date)[1]
g1_t = Tuple(gk1)
g1_nt = NamedTuple(gk1)
g1_dict = Dict(gk1)

gdf_city_date[1]
gdf_city_date[gk1]
gdf_city_date[g1_t]
gdf_city_date[g1_nt]
gdf_city_date[g1_dict]

gdf_city[("Olecko",)]
gdf_city[(city="Olecko",)]

using BenchmarkTools
bench_df = DataFrame(id=1:10^8);
bench_gdf = groupby(bench_df, :id);
@btime groupby($bench_df, :id);
bench_i = 1_000_000;
bench_gk = keys(bench_gdf)[bench_i];
bench_t = Tuple(bench_gk);
bench_nt = NamedTuple(bench_gk);
bench_dict = Dict(bench_gk);
@btime $bench_gdf[$bench_i];
@btime $bench_gdf[$bench_gk];
@btime $bench_gdf[$bench_t];
@btime $bench_gdf[$bench_nt];
@btime $bench_gdf[$bench_dict];

gdf_city[[2, 1]]
gdf_city[[1]]

[nrow(df) for df in gdf_city]

for p in pairs(gdf_city)
    println(p)
end

Dict(key.city => nrow(df) for (key, df) in pairs(gdf_city))

combine(gdf_city, nrow)
