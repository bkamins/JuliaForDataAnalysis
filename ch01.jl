# Bogumił Kamiński, 2021

# Codes for chapter 1

# Code from section 1.2.1

function f(n)
    s = 0
    for i in 1:n
        s += i
    end
    return s
end

@time f(1_000_000_000)

# Code allowing to reproduce the data frame presented in section 1.3

using DataFrames

DataFrame(a=1:3, name=["Alice", "Bob", "Clyde"],
          age=[19, 24, 21], friends=[[2], [1, 3], [2]],
          location=[(city="Atlanta", state="GA"),
                    (city="Boston", state="MA"),
                    (city="Austin", state="TX")])

# Code for comparison of languages

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
n-body,c,2.13,1633
mandelbrot,c,1.3,1135
spectral norm,c,0.41,1197
fannkuch-redux,c,7.58,910
fasta,c,0.78,1463
k-nucleotide,c,3.96,1506
binary-trees,c,1.58,809
reverse-complement,c,0.41,1965
pidigits,c,0.56,1090
regex-redux,c,0.8,1397
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
n-body,python,541.34,1196
mandelbrot,python,177.35,688
spectral norm,python,112.97,407
fannkuch-redux,python,341.45,950
fasta,python,36.9,1947
k-nucleotide,python,46.31,1967
binary-trees,python,44.7,660
reverse-complement,python,6.62,814
pidigits,python,1.16,567
regex-redux,python,1.34,1403
n-body,julia,4.21,1111
mandelbrot,julia,1.42,619
spectral norm,julia,1.11,429
fannkuch-redux,julia,7.83,1067
fasta,julia,1.13,1082
k-nucleotide,julia,4.94,951
binary-trees,julia,7.28,634
reverse-complement,julia,1.44,522
pidigits,julia,0.97,506
regex-redux,julia,1.74,759
"""

using CSV
using DataFrames
using Plots

df = CSV.read(IOBuffer(data), DataFrame)

plot(map([:time, :size],
         ["execution time (relative to C)",
          "code size (relative to C)"]) do col, title
    df_plot = unstack(df, :problem, :language, col)
    df_plot[!, Not(:problem)] ./= df_plot.c
    select!(df_plot, Not(:c))
    scatter(df_plot.problem, Matrix(select(df_plot, Not(:problem)));
            labels=permutedims(names(df_plot, Not(:problem))),
            title=title,
            yaxis = col == :time ? :log : :none,
            xrotation=20,
            markershape=[:circle :diamond :star5],
            markercolor=[:skyblue :orange :gold],
            xtickfontsize=5, ytickfontsize=5,
            legendfontsize=5, titlefontsize=6)
end...)
