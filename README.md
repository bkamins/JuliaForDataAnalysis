# Julia for Data Analysis

This repository contains source codes for the
["Julia for Data Analysis"](https://www.manning.com/books/julia-for-data-analysis?utm_source=bkamins&utm_medium=affiliate&utm_campaign=book_kaminski2_julia_3_17_22)
book that is written by Bogumił Kamiński and is planned to be published in 2022
by [Manning Publications Co.](https://www.manning.com/).

## Setting up your environment

In order to prepare the Julia environment before working with the materials
presented in the book please perform the following setup steps:

* [download](https://julialang.org/downloads/) and
  [install](https://julialang.org/downloads/platform/)
  [Julia](https://julialang.org/);
  all the codes were tested under Julia 1.7;
* make sure you can start Julia by running `julia` command in your terminal;
* download [this repository](https://github.com/bkamins/JuliaForDataAnalysis)
  to a local folder on your computer;
* start Julia in a folder containing the downloaded material using the command
  `julia --project`; the folder must
  contain the Project.toml and Manifest.toml files prepared for this book that
  allow Julia to automatically set up the project environment that will allow
  you to work with material presented in this book
  (a more detailed explanation what these files do and why they are required is
  given in Appendix A to the book);
* press *]*, write `instantiate` and press *Enter* (this process will ensure
  that Julia properly configures the working environment for working with
  the codes from the book);
* press *Backspace*, write `exit()` and press *Enter*; now you should exit Julia
  and everything is set up to work with the materials presented in the book.

Additional instructions how to manage your Julia installation are given in
Appendix A to the book. In particular I explain there how to perform a correct
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
*Start Julia REPL* command (e.g. under Windows its keyboard shortcut is Alt-J Alt-O)
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
chapter number. The only exception is chapter 14, where additionally a separate
*ch14_server.jl* is present along with *ch14.jl* (the reason is that in this
chapter we create a web service and the *ch14_server.jl* contains the
server-side code that should be run in a separate Julia process).

Solutions to the exercises that are presented in appendix B in
the book are stored in *appB.jl* file. These solutions assume that they are
executed in the same Julia session as the codes from the chapter where the
question was posted (so that appropriate variables and functions are defined
and appropriate packages are loaded).

## Running the example codes

To work with codes from some given chapter:

* it is recommended to use a machine with at least 8GB of RAM when working
  with the examples in this book;
* start a fresh Julia session using the `julia --project` command in a folder
  containing the downloaded material (or alternatively use Visual Studio Code
  to activate the appropriate project environment automatically);
* execute the commands sequentially as they appear in the file;
  the codes were prepared in a way that you do not need to restart Julia
  when working with material from a single chapter, unless it is explicitly
  written in the instructions to restart Julia (some of the codes require this);
* before each code there is a comment allowing you to locate the relevant part
  of the book where it is used; if in the code there is a blank line between
  consecutive code sections this means that in the book these codes are
  separated by the text of the book explaining what the code does

## Data used in the book

For your convenience I additionally stored data files that we use in this book.
They are respectively:

* movies.dat (for chapter 6, shared on GitHub repository
  <https://github.com/sidooms/MovieTweetings> under MIT license)
* puzzles.csv.bz2 (for chapter 8, available puzzles at
  <https://database.lichess.org/>. The data is distributed under
  Creative Commons CC0 license)
* git_web_ml.zip (for chapter 12, available on
  Stanford Large Network Dataset Collection website
  <https://snap.stanford.edu/data/github-social.html> under GPL-3.0 License)
* owensboro.zip (for chapter 13, available at The Stanford Open Policing Project
  under the Open Data Commons Attribution License)
