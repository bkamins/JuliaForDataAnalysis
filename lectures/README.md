# Julia for Data Analysis

## Contents

This folder contains Jupyter Notebooks with lecture templates to the book
["Julia for Data Analysis"](https://www.manning.com/books/julia-for-data-analysis?utm_source=bkamins&utm_medium=affiliate&utm_campaign=book_kaminski2_julia_3_17_22)
that is written by Bogumił Kamiński and is planned to be published in 2022
by [Manning Publications Co.](https://www.manning.com/).

The lecture tempates can be used as:
* starting point for preparation of teaching materials by instructors giving
  couses about data analysis using the Julia language.
* An alternative for the readers of the book to .jl files located in the root
  folder of this repository.

The notebooks were prepared by [Bogumił Kamiński](https://github.com/bkamins)
and [Daniel Kaszyński](https://www.linkedin.com/in/daniel-kaszy%C5%84ski-3a7807113/).

The files containing lecture template have a naming convention
`lectureDD.ipynb`, where `DD` is book chapter number for which the  were
prepared.

The differences from the codes presented in the book (the .jl files
in the root folder) are:

* code layout was changed (so it is not identical to code presented in the book);
* some codes adjusted or omitted in comparison to the book version, to make the
  presentation suitable for Jupyter Notebook format.

## Running instructions

The Jupyter Notebooks are stored in the *lectures* folder of the repository.
Therefore they will automatically use the information from
*Project.toml* and *Manifest.toml* files that are contained in the root
folder of the repository to properly set up the working environment.

However, before running Jupyter Notebooks you need to make sure that your
environment is properly configured to run Julia in Jupyter.

The notebooks were prepared under Julia 1.7, but they should work under newer
Julia 1.x versions. In this case what you might need to do is change Jupyter
Notebook kernel to the version of Julia that you have. In this case please
make sure to run the following command in projects root folder before
working with the notebooks:

```
julia --project -e "using Pkg; Pkg.instantiate()"
```

The simplest way to configure your environment is as follows:

* Start Julia in a terminal using `julia` command in the folder containing the
  lecture materials.
* press <kbd>]</kbd> to switch to package manager mode.
* Make sure you are in a home project environment. Your prompt should look as
  `(@v1.8) pkg>`. If it is not then run the `activate` command. Then you will
  switch to the home project environment. The reason why we do it is to avoid
  adding IJulia.jl to the local project environment of the book (as it could
  update some of the packages used in the book).
* Install the [IJulia.jl package](https://github.com/JuliaLang/IJulia.jl) by
  running command `add IJulia`.
* Rress <kbd>Backspace</kbd> to leave package manager mode.
* Run the command `using IJulia; notebook(dir=pwd())` that will start Jupyter
  in the current Julia directory. This directory should be the folder
  containing the lecture materials as we have started Julia in this folder. If
  you are not in this folder then instead of passing `pwd()` write a path to
  the folder where the lecture materials are located.

---

*Preparation of these exercises have been supported by the Polish National Agency for Academic Exchange under the Strategic Partnerships programme, grant number BPI/PST/2021/1/00069/U/00001.*

![SGH & NAWA](logo.png)

