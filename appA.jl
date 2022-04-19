# Bogumił Kamiński, 2021

# Codes for appendix A

# As opposed to all other files in this repository in the presented codes I
# do not assume that you have activated the project from the repository folder.
# Instead, please follow the instructions contained in the appendix A.

# starting Julia session

julia

# exiting Julia session

exit()

# getting help

?&&

# setting up the project environment for working with examples in the book
# D:\\JuliaForDataAnalysis is an example folder

cd("D:\\JuliaForDataAnalysis")
isfile("Project.toml")
isfile("Manifest.toml")
# switch to package manager mode by pressing ]
activate .
instantiate
# exit package manager mode by pressing backspace

# activating project environment in a given folder
activate D:\\JuliaForDataAnalysis\\

# setting up a new project folder

pwd()
# press ]
activate .
status
add BenchmarkTools
status
update
remove BenchmarkTools
status

# setting up integration with Python

# make sure you are in package manager mode
add PyCall
# press backspace
using PyCall
PyCall.python

# setting up integration with R

# make sure you are in package manager mode
add RCall
# press backspace
using RCall
RCall.Rhome
