This repository contains source codes for the "Julia for Data Analysis" book
that is written by Bogumił Kamiński and is planned to be published in 2022 by
[Manning Publications Co.](https://www.manning.com/).

In order to prepare the Julia environment before working with the materials
presented in the book please perform the following setup steps:
* [download](https://julialang.org/downloads/) and
  [install](https://julialang.org/downloads/platform/)
  [Julia](https://julialang.org/);
  all the codes were tested under Julia 1.7;
* make sure you can start Julia by running `julia` command in your system shell
  (alternative ways to use Julia are described in Appendix A to the book)
* download [this repository](https://github.com/bkamins/JuliaForDataAnalysis)
  to a local folder on your computer;
* start Julia in a folder containing the downloaded material using the command
  `julia --project`; the folder must
  contain the Project.toml and Manifest.toml files prepared for this book
  (an explanation what these files do and why they are required is given in
   Appendix A to the book);
* press *]*, write `instantiate` and press *Enter* (this process will ensure
  that Julia properly configures the working environment for working with
  the codes from the book);
* press *Backspace*, write `exit()` and press *Enter*; now you should exit Julia
  and everything is set up to work with the materials presented in the book.

The codes for each chapter are stored in files named *chXX.jl*, where *XX* is
chapter number.

To work with codes from some given chapter:
* start a fresh Julia session using the `julia --project` command in a folder
  containing the downloaded material;
* execute the commands sequentially as they appear in the file;
  the codes were prepared in a way that you do not need to restart Julia
  when working with material from a single chapter, unless it is explicitly
  written in the instructions to restart Julia (some of the codes require this).
