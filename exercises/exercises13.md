# Julia for Data Analysis

## Bogumił Kamiński, Daniel Kaszyński

# Chapter 13

# Problems

### Exercise 1

Download
https://archive.ics.uci.edu/ml/machine-learning-databases/00615/MushroomDataset.zip
archive and extract primary_data.csv and secondary_data.csv files from it.
Save the files to disk.

<details>
<summary>Solution</summary>

```
using Downloads
import ZipFile
Downloads.download("https://archive.ics.uci.edu/ml/machine-learning-databases/00615/MushroomDataset.zip", "MushroomDataset.zip")
archive = ZipFile.Reader("MushroomDataset.zip")
idx = only(findall(x -> contains(x.name, "primary_data.csv"), archive.files))
open("primary_data.csv", "w") do io
    write(io, read(archive.files[idx]))
end
idx = only(findall(x -> contains(x.name, "secondary_data.csv"), archive.files))
open("secondary_data.csv", "w") do io
    write(io, read(archive.files[idx]))
end
close(archive)
```

</details>

### Exercise 2

Load primary_data.csv into the `primary` data frame.
Load secondary_data.csv into the `secondary` data frame.
Describe the contents of both data frames.

<details>
<summary>Solution</summary>

```
using CSV
using DataFrames
primary = CSV.read("primary_data.csv", DataFrame; delim=';')
secondary = CSV.read("secondary_data.csv", DataFrame; delim=';')
describe(primary)
describe(secondary)
```

</details>

### Exercise 3

Start with `primary` data. Note that columns starting from column 4 have
their data encoded using vector notation, but they have been read-in as strings.
Convert these columns to hold proper vectors. Note that some columns have
`missing` values. Most of the columns hold nominal data, but three columns,
i.e. `cap-diameter`, `stem-height`, and `stem-width` have numeric data. These
should be parsed as vectors storing numeric values. After parsing, put these
three columns just after `class` column in the `parsed_primary` data frame.

Check `renamecols` keyword argument of `select` to
avoid renaming of the produced columns.

<details>
<summary>Solution</summary>

```
parse_nominal(s::AbstractString) = split(strip(s, ['[', ']']), ", ")
parse_nominal(::Missing) = missing
parse_numeric(s::AbstractString) = parse.(Float64, split(strip(s, ['[', ']']), ", "))
parse_numeric(::Missing) = missing
idcols = ["family", "name", "class"]
numericcols = ["cap-diameter", "stem-height", "stem-width"]
parsed_primary = select(primary,
                        idcols,
                        numericcols .=> ByRow(parse_numeric),
                        Not([idcols; numericcols]) .=> ByRow(parse_nominal);
                        renamecols=false)
```

</details>

### Exercise 4

In `parsed_primary` data frame find all pairs of mushrooms (rows) that might be
confused and have a different class, using the information about them we have
(so all information except their family, name, and class).

Use the following rules:
* if for some pair of mushrooms the data in some column for either of them is
  `missing` then skip matching on this column; for numeric columns if there
  is only one value in a vector then treat it as `missing`;
* otherwise:
  - for numeric columns check if there is an overlap in the interval
    specified by the min and max values for the range passed;
  - for nominal columns check if the intersection of nominal values is nonempty.

For each found pair print to the screen the row number, family, name, and class.

<details>
<summary>Solution</summary>

```
function overlap_numeric(v1, v2)
    # there are no missing values in numeric columns
    if length(v1) == 1 || length(v2) == 1
        return true
    else
        return max(v1[1], v2[1]) <= min(v1[2], v2[2])
    end
end

function overlap_nominal(v1, v2)
    if ismissing(v1) || ismissing(v2)
        return true
    else
        return !isempty(intersect(v1, v2))
    end
end

function rows_overlap(row1, row2)
    # note that in parsed_primary numeric columns have indices 4 to 6
    # and nominal columns have indices 7 to 23
    return all(i -> overlap_numeric(row1[i], row2[i]), 4:6) &&
           all(i -> overlap_nominal(row1[i], row2[i]), 7:23)
end

for i in 1:nrow(parsed_primary), j in i+1:nrow(parsed_primary)
    row1 = parsed_primary[i, :]
    row2 = parsed_primary[j, :]
    if rows_overlap(row1, row2) && row1.class != row2.class
        println((i, Tuple(row1[1:3]), j, Tuple(row2[1:3])))
    end
end
```

Note that in this exercise using `eachrow` is not a problem
(although it is not type stable) because the data is small.

</details>

### Exercise 5

Still using `parsed_primary` find what is the average probability of class being
`p` by `family`. Additionally add number of observations in each group. Sort
these results by the probability. Try using DataFramesMeta.jl to do this
exercise (this requirement is optional).

Store the result in `agg_primary` data frame.

<details>
<summary>Solution</summary>

```
using Statistics
using DataFramesMeta
agg_primary = @chain parsed_primary begin
    groupby(:family)
    @combine(:pr_p = mean(:class .== "p"), $nrow)
    sort(:pr_p)
end
```

</details>

### Exercise 6

Now using `agg_primary` data frame collapse it so that for each unique `pr_p`
it gives us a total number of rows that had this probability and a tuple
of mushroom family names.

Optionally: try to display the produced table so that the tuple containing the
list of families for each group is not cropped (this will require large
terminal).

<details>
<summary>Solution</summary>

```
show(combine(groupby(agg_primary, :pr_p), :nrow => sum => :nrow, :family => Tuple => :families); truncate=140)
```

</details>

### Exercise 7

From our preliminary analysis of `primary` data we see that `missing` value in
the primary data is non-informative, so in `secondary` data we should be
cautious when building a model if we allowed for missing data (in practice
if we were investigating some real mushroom we most likely would know its
characteristics).

Therefore as a first step drop in-place all columns in `secondary` data frame
that have missing values.

<details>
<summary>Solution</summary>

```
select!(secondary, [!any(ismissing, col) for col in eachcol(secondary)])
```

Note that we select based on actual contents of the columns and not by their
element type (column could allow for missing values but not have them).

</details>

### Exercise 8

Create a logistic regression predicting `class` based on all remaining features
in the data frame. You might need to check the `Term` usage in StatsModels.jl
documentation.

You will notice that for `stem-color` and `habitat` columns you get strange
estimation results (large absolute values of estimated parameters and even
larger standard errors). Explain why this happens by analyzing frequency tables
of these variables against `class` column.

<details>
<summary>Solution</summary>

```
using GLM
using FreqTables
secondary.class = secondary.class .== "p"
model = glm(Term(:class)~sum(Term.(Symbol.(names(secondary, Not(:class))))),
           secondary, Binomial(), LogitLink())
freqtable(secondary, "stem-color", "class")
freqtable(secondary, "habitat", "class")
```

We can see that for certain levels of `stem-color` and `habitat` variables
there is a perfect separation of classes.

</details>

### Exercise 9

Add `class_p` column to `secondary` as a second column that will contain
predicted probability from the model created in exercise 8 of a given
observation having class `p`.

Print descriptive statistics of column `class_p` by `class`.

<details>
<summary>Solution</summary>

```
insertcols!(secondary, 2, :class_p => predict(model))
combine(groupby(secondary, :class)) do sdf
    return describe(sdf, :detailed, cols=:class_p)
end
```

We can see that the model has some discriminatory power, but there
is still a significant overlap between classes.

</details>

### Exercise 10

Plot FPR-TPR ROC curve for our model and compute associated AUC value.

<details>
<summary>Solution</summary>

```
using Plots
using ROCAnalysis
roc_data = roc(secondary; score=:class_p, target=:class)
plot(roc_data.pfa, 1 .- roc_data.pmiss;
     title="AUC=$(round(100*(1 - auc(roc_data)), digits=2))%",
     xlabel="FPR", ylabel="TPR", legend=false)
```

</details>
