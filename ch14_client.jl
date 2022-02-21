using HTTP
using JSON3
using DataFrames
using Plots

df = DataFrame(K=30:2:80, max_time=0.25)
df.data = map(df.K, df.max_time) do K, max_time
    @show K
    @time req = HTTP.request("POST", "http://127.0.0.1:8000",
                            ["Content-Type" => "application/json"],
                            JSON3.write((;K, max_time)))
    return JSON3.read(req.body)
end

@assert all(==("OK"), getproperty.(df.data, :status))
df2 = select(df, :K, :data => ByRow(x -> x.value) => AsTable)
plot(plot(df2.K, df2.mv; legend=false, xlabel="K", ylabel="expected value"),
     plot(df2.K, df2.zero; legend=false, xlabel="K", ylabel="probability of zero"))
