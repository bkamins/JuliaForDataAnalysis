# Bogumił Kamiński, 2022

# Codes for chapter 5

# Code for listing 5.1

using HTTP
using JSON3
query = "https://api.nbp.pl/api/exchangerates/rates/a/usd/" *
        "2020-06-01/?format=json"
response = HTTP.get(query)
json = JSON3.read(response.body)

# Code for the remainder of section 5.1.2

response.body

String(response.body)

response.body

json.table
json.currency
json.code
json.rates

json.rates[1].mid

only(json.rates).mid

only([])
only([1, 2])

# Code for listing 5.2

query = "https://api.nbp.pl/api/exchangerates/rates/a/usd/" *
        "2020-06-06/?format=json"
response = HTTP.get(query)

# Code for listing 5.3

query = "https://api.nbp.pl/api/exchangerates/rates/a/usd/" *
        "2020-06-01/?format=json"
try
    response = HTTP.get(query)
    json = JSON3.read(response.body)
    only(json.rates).mid
catch e
    if e isa HTTP.ExceptionRequest.StatusError
        missing
    else
        rethrow(e)
    end
end

query = "https://api.nbp.pl/api/exchangerates/rates/a/usd/" *
        "2020-06-06/?format=json"
try
    response = HTTP.get(query)
    json = JSON3.read(response.body)
    only(json.rates).mid
catch e
    if e isa HTTP.ExceptionRequest.StatusError
        missing
    else
        rethrow(e)
    end
end

# Code for section 5.2

ismissing(missing)
ismissing(1)

1 + missing
sin(missing)

1 == missing
1 > missing
1 < missing

if missing
    print("this is not printed")
end
missing && true

coalesce(missing, true)
coalesce(missing, false)

isequal(1, missing)
isequal(missing, missing)
isless(1, missing)
isless(missing, missing)

isless(Inf, missing)

a = [1]
b = [1]
isequal(a, b)
a === b

x = [1, missing, 3, 4, missing]

coalesce.(x, 0)

sum(x)

y = skipmissing(x)

sum(y)

sum(skipmissing(x))

fun(x::Int, y::Int) = x + y
fun(1, 2)
fun(1, missing)

using Missings
fun2 = passmissing(fun)
fun2(1, 2)
fun2(1, missing)

# Code for section 5.3

using Dates
d = Date("2020-06-01")

typeof(d)
year(d)
month(d)
day(d)

dayofweek(d)
dayname(d)

Date(2020, 6, 1)

dates = Date.(2020, 6, 1:30)

Day(1)

d
d + Day(1)

Date(2020, 5, 20):Day(1):Date(2020, 7, 5)

collect(Date(2020, 5, 20):Day(1):Date(2020, 7, 5))

# Code for listing 5.6

function get_rate(date::Date)
    query = "https://api.nbp.pl/api/exchangerates/rates/" *
            "a/usd/$date/?format=json"
    try
        response = HTTP.get(query)
        json = JSON3.read(response.body)
        return only(json.rates).mid
    catch e
        if e isa HTTP.ExceptionRequest.StatusError
            return missing
        else
            rethrow(e)
        end
    end
end

# Code for showing how string interpolation works

"https://api.nbp.pl/api/exchangerates/rates/" *
"a/usd/$(dates[1])/?format=json"

"https://api.nbp.pl/api/exchangerates/rates/" *
"a/usd/$dates[1]/?format=json"

# Code for listing 5.7

rates = get_rate.(dates)

# Code for section 5.4

using Statistics
mean(rates)
std(rates)

mean(skipmissing(rates))
std(skipmissing(rates))

# Code for listing 5.8

using FreqTables
proptable(dayname.(dates), ismissing.(rates); margins=1)

# Code showing how to specify a complex condition using broadcasting

dayname.(dates) .== "Thursday" .&& ismissing.(rates)

# Code for listing 5.9

dates[dayname.(dates) .== "Thursday" .&& ismissing.(rates)]

# Codes for plotting exchange rate data

using Plots
plot(dates, rates; xlabel="day", ylabel="PLN/USD", legend=false)

rates_ok = .!ismissing.(rates)

plot(dates[rates_ok], rates[rates_ok];
     xlabel="day", ylabel="PLN/USD", legend=false)

using Impute
rates_filled = Impute.interp(rates)

scatter!(dates, rates_filled)
