module DailyTreasuryYieldCurve

using Reexport
using EzXML
using HTTP
using Dates
using Missings
@reexport using DataFrames



export getyieldcurves





const DATAFEED = "http://data.treasury.gov/feed.svc/DailyTreasuryYieldCurveRateData"
const DATAFEEDREAL = "http://data.treasury.gov/feed.svc/DailyTreasuryRealYieldCurveRateData"

# these fields are provided by the feed (as of 20200413)
# note that we must use :m1 because :1m is not a valid symbol
const COLNAMES = [:id,:date,:m1,:m2,:m3,:m6,:y1,:y2,:y3,:y5,:y7,:y10,:y20,:y30,:y30dup]
const COLNAMESREAL = [:id,:date,:y5,:y7,:y10,:y20,:y30]








"""
`getyieldcurves(;real::Bool=false)`

Download the whole published history of daily US Treasury yield curves from the official data feed.

Optionally, pass a filename if you have already downloaded the data, eg. `getyieldcurves(fn::AbstractString)`.

By default, gets the nominal yield curve. Pass `realrates=true` to get the real yield curve.  The nominal series starts in 1990, while the real series starts in 2003.

Returns a `DataFrame`.
"""
function getyieldcurves(;realrates::Bool=false)
    if realrates
        h = HTTP.get(DATAFEEDREAL)
    else
        h = HTTP.get(DATAFEED)
    end
    thexml = parsexml(String(h.body))
    return _parseyieldcurves(thexml,realrates)
end


function getyieldcurves(fn::AbstractString;realrates::Bool=false)
    thexml = readxml(fn)
    return _parseyieldcurves(thexml,realrates)
end



"""
`_parseyieldcurves(thexml,realrates)`

Parser function for Treasury yield curve data. (unexported)
"""
function _parseyieldcurves(thexml,realrates)
    if realrates
        return _parserealcurves(thexml)
    else
        return _parsenominalcurves(thexml)
    end
end

function _parsenominalcurves(thexml)
    r = thexml.root
    cnod=findall("/*/*/*[position()=7]",r)
    @assert length(cnod) >= 1 "Rate XML parse error likely."

    stripsplitstrip(s) = strip.(split(strip(s),"\n"))

    strarr = map(stripsplitstrip,nodecontent.(cnod))
    df=DataFrame(Tuple.(strarr))
    @assert nrow(df) >= 1 "Rate XML parse error likely."

    rename!(df,COLNAMES)
    select!(df,Not([:id; :y30dup]))
    for c in COLNAMES[2:end-1]
        if c == :date
            df[!,c] = Date.(parse.(DateTime,df[!,c]))
        else
            df[!,c] = passmissing(x->parse(Float64,x)).(replace(df[!,c],""=>missing))
        end
    end
    sort!(df,:date)
    return df
end


function _parserealcurves(thexml)
    r = thexml.root
    cnod=findall("/*/*/*[position()=7]",r)
    @assert length(cnod) >= 1 "Rate XML parse error likely."


    nodestr = nodecontent.(cnod)
    
    function splitandfill(s)
        spl = split(s)
        L = length(spl)
        L == length(COLNAMESREAL) && return spl

        strvec = Vector{eltype(spl)}(undef,length(COLNAMESREAL))
        for i in 1:length(COLNAMESREAL)
            if i <= L
                strvec[i] = spl[i]
            else
                strvec[i] = ""
            end
        end
        return strvec
    end

    strarr = splitandfill.(nodestr)
    df=DataFrame(Tuple.(strarr))
    @assert nrow(df) >= 1 "Rate XML parse error likely."

    rename!(df,COLNAMESREAL)
    select!(df,Not(:id))
    for c in COLNAMESREAL[2:end]
        if c == :date
            df[!,c] = Date.(parse.(DateTime,df[!,c]))
        else
            df[!,c] = passmissing(x->parse(Float64,x)).(replace(df[!,c],""=>missing))
        end
    end
    sort!(df,:date)
    return df
end


    






end # module
