# Bogumił Kamiński, 2021

# Codes for chapter 1

# Code from section 1.2.1

function sum_n(n)
    s = 0
    for i in 1:n
        s += i
    end
    return s
end

@time sum_n(1_000_000_000)

# Code from section 1.4

@time using Plots
@time plot(1:10)
@time plot(1:10)

# Code allowing to reproduce the data frame presented in section 1.3

using DataFrames

DataFrame(a=1:3, name=["Alice", "Bob", "Clyde"],
          age=[19, 24, 21], friends=[[2], [1, 3], [2]],
          location=[(city="Atlanta", state="GA"),
                    (city="Boston", state="MA"),
                    (city="Austin", state="TX")])

# Code for comparison of languages in figure 1.1

# Source of data:
#   * https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/julia-gcc.html
#   * https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/julia-python3.html
#   * https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/julia.html
# Download date:
#   29.01.2022
# Programming language versions used:
#   * Julia:    julia version 1.7.1
#   * Python 3: Python 3.10.1
#   * C:        gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0
#   * Java      openjdk 17.0.1 2021-10-19
#               OpenJDK Runtime Environment (build 17.0.1+12-39)
#               OpenJDK 64-Bit Server VM (build 17.0.1+12-39, mixed mode, sharing)

data = """
problem,language,time,size
n-body,C,2.13,1633
mandelbrot,C,1.3,1135
spectral norm,C,0.41,1197
fannkuch-redux,C,7.58,910
fasta,C,0.78,1463
k-nucleotide,C,3.96,1506
binary-trees,C,1.58,809
reverse-complement,C,0.41,1965
pidigits,C,0.56,1090
regex-redux,C,0.8,1397
n-body,Java,6.77,1489
mandelbrot,Java,4.1,796
spectral norm,Java,1.55,756
fannkuch-redux,Java,10.48,1282
fasta,Java,1.2,2543
k-nucleotide,Java,4.83,1812
binary-trees,Java,2.51,835
reverse-complement,Java,1.57,2183
pidigits,Java,0.79,764
regex-redux,Java,5.34,929
n-body,Python,541.34,1196
mandelbrot,Python,177.35,688
spectral norm,Python,112.97,407
fannkuch-redux,Python,341.45,950
fasta,Python,36.9,1947
k-nucleotide,Python,46.31,1967
binary-trees,Python,44.7,660
reverse-complement,Python,6.62,814
pidigits,Python,1.16,567
regex-redux,Python,1.34,1403
n-body,Julia,4.21,1111
mandelbrot,Julia,1.42,619
spectral norm,Julia,1.11,429
fannkuch-redux,Julia,7.83,1067
fasta,Julia,1.13,1082
k-nucleotide,Julia,4.94,951
binary-trees,Julia,7.28,634
reverse-complement,Julia,1.44,522
pidigits,Julia,0.97,506
regex-redux,Julia,1.74,759
"""

using CSV
using DataFrames
using Plots

df = CSV.read(IOBuffer(data), DataFrame)

plot(map([:time, :size],
         ["execution time (relative to C)",
          "code size (relative to C)"]) do col, title
    df_plot = unstack(df, :problem, :language, col)
    df_plot[!, Not(:problem)] ./= df_plot.C
    select!(df_plot, Not(:C))
    scatter(df_plot.problem, Matrix(select(df_plot, Not(:problem)));
            labels=permutedims(names(df_plot, Not(:problem))),
            ylabel=title,
            yaxis = col == :time ? :log : :none,
            xrotation=20,
            markershape=[:rect :diamond :circle],
            markersize=[4 5 5],
            markercolor=[:lightgray :lightgray :gold],
            xtickfontsize=7, ytickfontsize=7,
            legendfontsize=7, ylabelfontsize=7)
            hline!([1.0]; color="orange", labels="C")
end...)
