
# Treasury uses Act/Act (ICMA) day count convention
# unclear how this translates to constant maturities
# I use months = 30 days, years = 365 days
const DAYSTOMATURITY = [30,60,90,180,365,730,1095,1825,2555,3650,7300,10950]
const DAYSTOMATURITYREAL = [1825,2555,3650,7300,10950]


const TTM = (;Iterators.zip(DailyTreasuryYieldCurve.COLNAMES[3:end-1],DAYSTOMATURITY)...)
const TTMREAL = (;Iterators.zip(DailyTreasuryYieldCurve.COLNAMESREAL[3:end],DAYSTOMATURITYREAL)...)




"""
`RateInterpolator`

A container for the series of daily yield curve interpolators.

Fields: `dates` and `interpolators`, both `Vector`.

To interpolate, just call it with the value to interpolate (days to maturity) and the date of the curve.
```
(ri::RateInterpolator)(d::Real,dt::Date)
```

Currently supports only linear interpolation and extrapolation. See [`createRateInterpolator`](@ref) for construction.
"""
struct RateInterpolator{T}
    dates::Vector{Date}
    interpolators::Vector{T}
    realrates::Bool
end



function (ri::RateInterpolator)(d::Real,dt::Date)
    idx = searchsortedlast(ri.dates,dt)
    return ri.interpolators[idx](d)
end



"""
`createRateInterpolator(df;realrates::Bool=false)`

Preferred method to construct a [`RateInterpolator`](@ref), just pass the `df` that you get from [`getyieldcurves`](@ref).
"""
function createRateInterpolator(df0;realrates::Bool=false)
    loc = [!all(ismissing(x) for x in r) for r in eachrow(select(df0,Not(:date)))] # 0 for rows with only missing data
    df = df0[loc,:]
    dates = unique(df.date)

    dfs = DataFrames.stack(df,Not(:date))
    if realrates
        dfs.DTM = [TTMREAL[k] for k in dfs.variable]
    else
        dfs.DTM = [TTM[k] for k in dfs.variable]
    end

    gd = groupby(dfs,:date)
    rateinterps = [buildsingleinterpolator(g) for g in gd]
    
    @assert length(dates) == length(rateinterps) "Number of dates is different than number of daily interpolators."

    return RateInterpolator(dates,rateinterps,realrates)
end


"""
`buildsingleinterpolator(df::AbstractDataFrame)`

Builds a single (one day) interpolation of the yield curve. Used in `createRateInterpolator`.
"""
function buildsingleinterpolator(df::AbstractDataFrame)
    dfdm = dropmissing(df)
    x = dfdm.DTM
    y = dfdm.value
    itp = LinearInterpolation(x,y,extrapolation_bc=Line())
    return itp
end


function Base.show(io::IO, ri::RateInterpolator)
    itpT = Interpolations.itptype(first(ri.interpolators))
    begdt = first(ri.dates)
    enddt = last(ri.dates)
    ndays = length(ri.dates)
    kind = ri.realrates ? "Real" : "Nominal"
    print(io,"$kind RateInterpolator{$itpT interpolators} starting $begdt and ending $enddt ($ndays days)")
end



