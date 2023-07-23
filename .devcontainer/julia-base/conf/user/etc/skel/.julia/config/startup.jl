println("Executing user-specific startup file (", @__FILE__, ")...")

# https://github.com/julia-vscode/julia-vscode/issues/3304
project = (Base.JLOptions().project != C_NULL ?
    unsafe_string(Base.JLOptions().project) :
    get(ENV, "JULIA_PROJECT", nothing))
if !isnothing(project)
    Pkg.activate(; io=devnull)
end

try
    using Revise
    println("Revise started")
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

if !isnothing(project) &&
    # https://github.com/julia-vscode/julia-vscode/issues/3304
    !startswith(Base.load_path_expand(Base.LOAD_PATH[end]), project)

    if startswith(project, "@")
        if startswith(project, "@.")
            if isnothing(Base.current_project())
                Pkg.activate(joinpath("$(ENV["HOME"])", ".julia",
                        "environments", "v$(VERSION.major).$(VERSION.minor)"))
            else
                Pkg.activate(Base.current_project(); io=devnull)
            end
        else
            Pkg.activate(Base.load_path_expand(project); io=devnull)
        end
    else
        Pkg.activate(abspath(expanduser(project)); io=devnull)
    end
else
    if isfile(joinpath(pwd(), "Project.toml")) &&
        isfile(joinpath(pwd(), "Manifest.toml"))

        Pkg.activate(pwd())
    else
        Pkg.activate(joinpath("$(ENV["HOME"])", ".julia", "environments",
                "v$(VERSION.major).$(VERSION.minor)"))
    end
end
