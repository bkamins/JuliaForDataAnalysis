## Errata

This file contains errata for the
["Julia for Data Analysis"](https://www.manning.com/books/julia-for-data-analysis?utm_source=bkamins&utm_medium=affiliate&utm_campaign=book_kaminski2_julia_3_17_22)
book that has been written by Bogumił Kamiński and has been published by [Manning Publications Co.](https://www.manning.com/)

### Chapter 2, introduction, page 20

* middle of page 20: the provided link http://mng.bz/5mWD explaining *k-times winsorized mean* definition no longer works.
  Use https://web.archive.org/web/20210804184830/https://v8doc.sas.com/sashtml/insight/chap38/sect17.htm provided by
  [The Wayback Machine](https://web.archive.org/) instead.

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

### Chapter 2, section 2.5, page 45

* top of page 45: *use in this book):* should be *use in this book:*

### Chapter 3, section 3.2.3, page 58

* middle of page 58: `y[end - the + 1] = y[end -- k]` should be `y[end - i + 1] = y[end - k]`

### Chapter 3, section 3.2.3, page 59

* top of page 59: `sort(v::AbstractVector; kwthe.)` should be `sort(v::AbstractVector; kws...)`

### Chapter 6, section 6.4.1, page 132

* middle of Listing 6.4: `codeunits("?")` should be `codeunits("ε")`

### Chapter 8, section 8.1.2, page 189

* middle of page 189: `zsdf format` should be `zstd format`

### Chapter 8, section 8.2.1, page 191

* bottom of page 191: `misssingstring` should be `missingstring`

### Chapter 9, section 9.2.2, page 231

* top of page 191: `both ratings` should be `ratings`

### Chapter 10, section 10.2.2, page 255

* bottom of page 255: `? Error: Error adding value to column :b.` should be `┌ Error: Error adding value to column :b.`

### Chapter 12, section 12.1.4, page 302

* bottom of page 302:

```
julia> df = DataFrame(a=1:3, b=1:3, c=1:3)
3×3 DataFrame
 Row │ a      b      c
     │ Int64  Int64  Int64
???????????????????????????
   1 │     1      1      1
   2 │     2      2      2
   3 │     3      3      3
```

should be

```
julia> df = DataFrame(a=1:3, b=1:3, c=1:3)
3×3 DataFrame
 Row │ a      b      c
     │ Int64  Int64  Int64
─────┼─────────────────────
   1 │     1      1      1
   2 │     2      2      2
   3 │     3      3      3
```

### Chapter 12, section 12.3.2, page 318

* top of page 318: in the annotation to Figure 12.6 there is text *Applies a log1p* which looks like *Applies a loglp*
  (this is a display issue due to the fact that in the font used letter `l` and digit `1` look identical)
