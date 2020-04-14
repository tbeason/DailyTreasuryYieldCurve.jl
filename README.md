# DailyTreasuryYieldCurve.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/tbeason/DailyTreasuryYieldCurve.jl.svg?branch=master)](https://travis-ci.com/tbeason/DailyTreasuryYieldCurve.jl)
[![codecov.io](http://codecov.io/github/tbeason/DailyTreasuryYieldCurve.jl/coverage.svg?branch=master)](http://codecov.io/github/tbeason/DailyTreasuryYieldCurve.jl?branch=master)
<!--
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://tbeason.github.io/DailyTreasuryYieldCurve.jl/stable)
[![Documentation](https://img.shields.io/badge/docs-master-blue.svg)](https://tbeason.github.io/DailyTreasuryYieldCurve.jl/dev)
-->

This package does one thing: gets you daily yield curves from the [US Treasury](https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yield). The data is served via an XML feed, but this package cleans it up into a `DataFrame` so that you can use it.


Structure of returned data for nominal curve:

| Column Name | Description |
| ---- | ---- |
| date | Date of yield curve |
| m1 | 1 month constant maturity rate |
| m2 | 2 month constant maturity rate |
| m3 | 3 month constant maturity rate |
| m6 | 6 month constant maturity rate |
| y1 | 1 year constant maturity rate |
| y2 | 2 year constant maturity rate |
| y3 | 3 year constant maturity rate |
| y5 | 5 year constant maturity rate |
| y7 | 7 year constant maturity rate |
| y10 | 10 year constant maturity rate |
| y20 | 20 year constant maturity rate |
| y30 | 30 year constant maturity rate |


Structure of returned data for real curve:

| Column Name | Description |
| ---- | ---- |
| date | Date of yield curve |
| y5 | 5 year constant maturity real rate |
| y7 | 7 year constant maturity real rate |
| y10 | 10 year constant maturity real rate |
| y20 | 20 year constant maturity real rate |
| y30 | 30 year constant maturity real rate |


Not all maturities were reported on every day.

# Example

```julia
using DailyTreasuryYieldCurve

df_rates = getyieldcurves()

df_realrates = getyieldcurves(;realrates=true)

```






## Disclaimer

This package is provided as-is and without guarantees. I am not affiliated with the US Treasury. Please cite the original source when using this data.
