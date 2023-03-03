# Julia for Data Analysis

This repository contains source codes for the
["Julia for Data Analysis"](https://www.manning.com/books/julia-for-data-analysis?utm_source=bkamins&utm_medium=affiliate&utm_campaign=book_kaminski2_julia_3_17_22)
book that has been written by Bogumił Kamiński and has been published by [Manning Publications Co.](https://www.manning.com/)

## Contents

* [Additional teaching materials](#additional-teaching-materials)
* [Setting up your environment](#setting-up-your-environment)
  * [General instructions](#general-instructions)
  * [Note for Linux users](#note-for-linux-users)
* [Organization of the code](#organization-of-the-code)
* [Running the example codes](#running-the-example-codes)
* [Accompanying materials](#accompanying-materials)
* [Data used in the book](#data-used-in-the-book)
* [Citation](#citation)
* [Errata](#errata)

## Additional teaching materials
* in the `/exercises` folder for each book chapter you can find 10 additional
  exercises with solutions (they are meant for self study and are not discussed
  in the book)
* in the `/lectures` folder for each book chapter you can find a Jupyter
  Notebook file with code from this chapter (note that the code is slightly
  adjusted in comparison to code contained in .jl files in the root folder
  to accommodate it for running in Jupyter Notebook).

## Setting up your environment

### General instructions

In order to prepare the Julia environment before working with the materials
presented in the book please perform the following setup steps:

* [download](https://julialang.org/downloads/) and
  [install](https://julialang.org/downloads/platform/)
  [Julia](https://julialang.org/);
  all the codes were tested under Julia 1.7 (under never versions of Julia
  the code will work, but you might get warning messages when loading packages
  due to the fact that their versions are pinned in this repository);
* make sure you can start Julia by running `julia` command in your terminal;
* download [this repository](https://github.com/bkamins/JuliaForDataAnalysis)
  to a local folder on your computer;
* start Julia in a folder containing the downloaded material using the command
  `julia --project`; the folder must
  contain the Project.toml and Manifest.toml files prepared for this book that
  allow Julia to automatically set up the project environment that will allow
  you to work with material presented in this book
  (a more detailed explanation what these files do and why they are required is
  given in appendix A to the book);
* press <kbd>]</kbd>, write `instantiate` and press <kbd>Enter</kbd> (this
  process will ensure that Julia properly configures the working environment
  for working with the codes from the book); in some cases
  running the `resolve` command also might be required;
* press <kbd>Backspace</kbd>, write `exit()` and press <kbd>Enter</kbd>;
  now you should exit Julia and everything is set up to work with the materials
  presented in the book.

Additional instructions how to manage your Julia installation are given in
appendix A to the book. In particular I explain there how to perform a correct
configuration of your environment when doing:

* integration with Python using the PyCall.jl package;
* integration with R using the RCall.jl package;
* installation of Plots.jl (which by default uses the GR Framework that requires
  installation of extra dependencies on operating system level under Linux).

In particular, if you use
[Visual Studio Code](https://code.visualstudio.com/) with
[Julia extension](https://marketplace.visualstudio.com/items?itemName=julialang.language-julia)
then open the folder with the materials contained in this repository (you can
open it in Folder/Open Folder... menu option). Then if you run
*Start Julia REPL* command (e.g. under Windows its keyboard shortcut is
<kbd>Alt</kbd>-<kbd>J</kbd> <kbd>Alt</kbd>-<kbd>O</kbd>)
a proper project environment will be automatically activated (the Julia extension
will use the Project.toml and Manifest.toml files that are present in this folder).

### Note for Linux users

Installation of Julia under Linux requires that you choose the folder to which
you extract the precompiled binaries you have downloaded. Next, assuming that
you extracted Julia in, for example, the `/opt` folder, the simplest way
to make sure that your system can find `julia` executable is to add it to
your system `PATH` environment variable. A standard way to do it is to
edit your `~/.bashrc` (or `~/.bash_profile`) file and add there the:

```text
export PATH="$PATH:/opt/julia-1.7.2/bin"
```

line (assuming you have downloaded Julia 1.7.2 and extracted it to `/opt` folder).

## Organization of the code

The codes for each chapter are stored in files named *chXX.jl*, where *XX* is
chapter number. The exceptions are

* chapter 14, where additionally a separate *ch14_server.jl* is present along
  with *ch14.jl* (the reason is that in this chapter we create a web service and
  the *ch14_server.jl* contains the server-side code that should be run in a
  separate Julia process);
* appendix A, where the file name used is *appA.txt* because it also
  contains other instructions than only Julia code (in particular package
  manager mode instructions).

Solutions to the exercises that are presented in appendix B in
the book are stored in *appB.jl* file. These solutions assume that they are
executed in the same Julia session as the codes from the chapter where the
question was posted (so that appropriate variables and functions are defined
and appropriate packages are loaded).

## Running the example codes

To work with codes from some given chapter:

* it is recommended to use a machine with at least 8GB of RAM when working
  with the examples in this book (some examples require more RAM, which
  is clearly indicated in the book);
* start a fresh Julia session using the `julia --project` command in a folder
  containing the downloaded material (or alternatively use Visual Studio Code
  to activate the appropriate project environment automatically);
* execute the commands sequentially as they appear in the file;
  the codes were prepared in a way that you do not need to restart Julia
  when working with material from a single chapter, unless it is explicitly
  written in the instructions to restart Julia (some of the codes require this);
  when you move to a new chapter start a new Julia session;
* before each code there is a comment allowing you to locate the relevant part
  of the book where it is used; if in the code there is a blank line between
  consecutive code sections this means that in the book these codes are
  separated by the text of the book explaining what the code does;

## Accompanying materials

There are the following videos that feature material related to this book:
* [Analysis of Lichess puzzles database](https://www.twitch.tv/videos/1483517202)
  (a shortened version of material covered in chapters 8 and 9); also covered
  in [this blogpost](https://bkamins.github.io/julialang/2022/05/12/twitch.html);
* [Analysis of GitHub developer graph](https://www.twitch.tv/videos/1527593261)
  (a shortened version of material covered in chapter 12)

## Data used in the book

For your convenience I additionally stored data files that we use in this book.
They are respectively:

* movies.dat (for chapter 6, shared on GitHub repository
  <https://github.com/sidooms/MovieTweetings> under MIT license)
* puzzles.csv.bz2 (for chapter 8, available puzzles at
  <https://database.lichess.org/>. The data is distributed under
  Creative Commons CC0 license);
* git_web_ml.zip (for chapter 12, available on
  Stanford Large Network Dataset Collection website
  <https://snap.stanford.edu/data/github-social.html> under GPL-3.0 License)
* owensboro.zip (for chapter 13, available at The Stanford Open Policing Project
  under the Open Data Commons Attribution License)

## Citation

#### Plain text (Chicago style):

Kamiński, Bogumił. 2023. *Julia for Data Analysis*. Manning.

#### BibTeX:

```
@book{Kaminski2023,
  title     = "Julia for Data Analysis",
  author    = "Kamiński, Bogumił",
  year      = 2023,
  publisher = "Manning",
  address   = "Shelter Island, NY"
}
```

## Errata


### Chapter 1, section 1.2.1, page 7

I show the following example of code execution:

```
julia> function sum_n(n)
           s = 0
           for i in 1:n
               s += i
           end
           return s
       end
sum_n (generic function with 1 method)

julia> @time sum_n(1_000_000_000)
  0.000001 seconds
500000000500000000
```

This timining is very fast (and the reason is explained in the book).
The issue is that this is the situation under Julia 1.7.

Under Julia 1.8 and Julia 1.9 running the same code takes longer (tested under Julia 1.9-beta4):

```
julia> @time sum_n(1_000_000_000)
  2.265569 seconds
500000000500000000
```

The reason for this inconsistency is a bug in `@time` macro introduced in Julia 1.8 release.
The `sum_n(1_000_000_000)` call (without `@time`) is executed fast.
Here is a simplified benchmark (run under Julia 1.9-beta4):

```
julia> let
           start = time_ns()
           v = sum_n(1_000_000_000)
           stop=time_ns()
           v, Int(stop - start)
       end
(500000000500000000, 1000)
```

Unfortunately there is an issue with the `@time`
macro used in global scope, that needs to be resolved in Base Julia.
See [this issue](https://github.com/JuliaLang/julia/issues/47561).

### Chapter 2, section 2.3.1, page 30

I compare the following expressions:

```
x > 0 && println(x)
```

and

```
if x > 0
    println(x)
end
```

where `x = -7`.

I write there that Julia interprets them both in the same way.
It is true in terms of the fact that in both cases the `println` function is not called (and this is the focus point of the example).
However, there is a difference in the value of these expressions.
The first expression evaluates to `false`, while the second evaluates to `nothing`.

Here is how you can check it:

```
julia> x = -7
-7

julia> show(x > 0 && println(x))
false
julia> show(if x > 0
           println(x)
       end)
nothing
```

### Chapter 3, section 3.2.3, pages 58

* middle of page 58: `y[end - the + 1] = y[end -- k]` should be `y[end - i + 1] = y[end - k]`

### Chapter 3, section 3.2.3, pages 59

* top of page 59: `sort(v::AbstractVector; kwthe.)` should be `sort(v::AbstractVector; kws...)`

### Chapter 6, section 6.4.1, page 132

* middle of Listing 6.4: `codeunits("?")` should be `codeunits("ε")`

### Chapter 8, section 8.1.2, page 189

* middle of page 189: `zsdf format` should be `zstd format`

### Chapter 8, section 8.2.1, page 191

* bottom of page 191: `misssingstring` should be `missingstring`

### Chapter 10, section 10.2.2, page 255

* bottom of page 255: `? Error: Error adding value to column :b.` should be `┌ Error: Error adding value to column :b.`
