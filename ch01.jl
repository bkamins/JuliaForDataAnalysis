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
