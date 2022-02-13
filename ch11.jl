# Bogumił Kamiński, 2022

# Codes for chapter 11

# Code for section 11.1

# Code for a note on conversion

x = [1.5]
x[1] = 1
x

# Code from section 11.1.1

using Serialization
walk = deserialize("walk.bin")

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
