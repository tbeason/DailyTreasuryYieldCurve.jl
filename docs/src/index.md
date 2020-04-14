# DailyTreasuryYieldCurve

[DailyTreasuryYieldCurve.jl](https://github.com/tbeason/DailyTreasuryYieldCurve.jl) is a Julia package for downloading and working with historical daily yield curve data from the [US Treasury](https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yield).

## Getting Daily Yield Curves

```@docs
getyieldcurves
```

Structure of returned data for *nominal* curve:

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


Structure of returned data for *real* curve:

| Column Name | Description |
| ---- | ---- |
| date | Date of yield curve |
| y5 | 5 year constant maturity real rate |
| y7 | 7 year constant maturity real rate |
| y10 | 10 year constant maturity real rate |
| y20 | 20 year constant maturity real rate |
| y30 | 30 year constant maturity real rate |


Not all maturities were reported on every day.


## Interpolation

The package contains some convenience utilities for interpolating/extrapolating with the yield curve data.

```@docs
RateInterpolator
createRateInterpolator
```


## Day Count Convention

The standard day count convention for valuing US Treasuries is [Actual/Actual (ICMA)](https://en.wikipedia.org/wiki/Day_count_convention#Actual/Actual_ICMA) (as opposed to something like 30/360). However, it is unclear (to me) exactly how to match this to constant maturities. Therefore, I use the convention that months are 30 days (for maturities less than 1 year) and years are 365 days (for maturities 1 year or more).