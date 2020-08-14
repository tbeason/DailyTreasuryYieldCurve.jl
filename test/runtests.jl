using DailyTreasuryYieldCurve, Dates
using Test

testdf = getyieldcurves()

@testset "Nominal" begin
    
    @test Symbol.(names(testdf)) == DailyTreasuryYieldCurve.COLNAMES[2:end-1]

    @test testdf[1,:date] == Date(1990,1,2)

    @test isapprox(testdf[1,:y30],8.0)
end


@testset "Real" begin
    testdfr = getyieldcurves(;realrates=true)

    @test Symbol.(names(testdfr)) == DailyTreasuryYieldCurve.COLNAMESREAL[2:end]

    @test testdfr[1,:date] == Date(2003,1,2)

    @test isapprox(testdfr[1,:y5],1.752231)
end


@testset "Interpolation" begin
    # testdf = getyieldcurves()
    testri = createRateInterpolator(testdf)

    @test isapprox(testri(45,Date(2020,4,13)),0.23)

    @test isapprox(testri.([30;60],Date(2020,4,13)),[0.17;0.29])
end


@testset "Filters" begin
    # testdf = getyieldcurves()
    smalltestdf = getyieldcurves(;begdt=Date(2019,1,1),enddt=Date(2019,12,31))
    filter!(row->Date(2019,1,1) <= row.date <= Date(2019,12,31),testdf)

    @test testdf == smalltestdf
end
