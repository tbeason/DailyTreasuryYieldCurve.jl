# DailyTreasuryYieldCurve.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/tbeason/DailyTreasuryYieldCurve.jl.svg?branch=master)](https://travis-ci.com/tbeason/DailyTreasuryYieldCurve.jl)
[![codecov.io](http://codecov.io/github/tbeason/DailyTreasuryYieldCurve.jl/coverage.svg?branch=master)](http://codecov.io/github/tbeason/DailyTreasuryYieldCurve.jl?branch=master)

[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://tbeason.github.io/DailyTreasuryYieldCurve.jl/stable)
<!---[![Documentation](https://img.shields.io/badge/docs-master-blue.svg)](https://tbeason.github.io/DailyTreasuryYieldCurve.jl/dev)-->


This Julia package does one thing: gets you daily yield curves from the [US Treasury](https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yield). The data is served via an XML feed, but this package cleans it up into a `DataFrame` so that you can use it.





# Example

Add the package via the Julia Package Manager.
```julia
] add DailyTreasuryYieldCurve
```

It is easy to get the historical yield curves:
```julia
using DailyTreasuryYieldCurve

df_rates = getyieldcurves()

df_realrates = getyieldcurves(;realrates=true)
```

You can also build a `RateInterpolator` which helps you interpolate/extrapolate using the data:
```julia
using Dates

nominal_itp = createRateInterpolator(df_rates)

nominal_itp(45,Date(2020,4,13)) # gets the 45 day rate on 2020-4-13
```


For more information check the [documentation](https://tbeason.github.io/DailyTreasuryYieldCurve.jl/stable).



## Disclaimer

This package is provided as-is and without guarantees. I am not affiliated with the US Treasury. Please cite the original source when using this data.
