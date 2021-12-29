# Bogumił Kamiński, 2021

# Codes for appendix B

# Code for exercise 3.1

using Statistics
using BenchmarkTools
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
@benchmark [cor($aq[:, i], $aq[:, i+1]) for i in 1:2:7]
@benchmark [cor(view($aq, :, i), view($aq, :, i+1)) for i in 1:2:7]

# Code for exercise 3.2

function dice_distribution(dice1, dice2)
    distribution = Dict{Int, Int}()
    for i in dice1
        for j in dice2
            s = i + j
            if haskey(distribution, s)
                distribution[s] += 1
            else
                distribution[s] = 1
            end
        end
    end
    return distribution
end

function test_dice()
    all_dice = [[1, x2, x3, x4, x5, x6]
                for x2 in 2:11
                for x3 in x2:11
                for x4 in x3:11
                for x5 in x4:11
                for x6 in x5:11]

    two_standard = dice_distribution(1:6, 1:6)

    for d1 in all_dice, d2 in all_dice
        test = dice_distribution(d1, d2)
        if test == two_standard
            println(d1, " ", d2)
        end
    end
end

test_dice()


# Code for exercise 3.3

plot(scatter(data.set1.x, data.set1.y, legend=false),
     scatter(data.set2.x, data.set2.y, legend=false),
     scatter(data.set3.x, data.set3.y, legend=false),
     scatter(data.set4.x, data.set4.y, legend=false))
