using DailyTreasuryYieldCurve, Dates
using Test

@testset "Nominal" begin
    testdf = getyieldcurves()

    @test names(testdf) == DailyTreasuryYieldCurve.COLNAMES[2:end-1]

    @test testdf[1,:date] == Date(1990,1,2)

    @test isapprox(testdf[1,:y30],8.0)
end


@testset "Real" begin
    testdf = getyieldcurves(;realrates=true)

    @test names(testdf) == DailyTreasuryYieldCurve.COLNAMESREAL[2:end]

    @test testdf[1,:date] == Date(2003,1,2)

    @test isapprox(testdf[1,:y5],1.752231)
end


@testset "Interpolation" begin
    testdf = getyieldcurves()
    testri = createRateInterpolator(testdf)

    @test isapprox(testri(45,Date(2020,4,13)),0.23)

    @test isapprox(testri.([30;60],Date(2020,4,13)),[0.17;0.29])
end
