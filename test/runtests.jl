using Ratios, Test
using FixedPointNumbers

# FIXME tests for AbstractRatio

@testset "SimpleRatio" begin
    r = SimpleRatio(1,2)
    @test convert(Float64, r) === Float64(r) === 0.5
    @test convert(Float32, r) === Float32(r) === 0.5f0
    @test convert(BigFloat, r) == BigFloat(r) == BigFloat(1)/2

    r2 = SimpleRatio(2,3)
    @test r*r2 == SimpleRatio(2,6) == SimpleRatio(1,3)
    @test r2*3 == 3*r2 == 2
    @test r*false == false*r == 0
    @test r/r2 == SimpleRatio(3,4)
    @test r/2 == SimpleRatio(1,4)
    @test 2/r == 4
    @test 4 == 2/r
    @test r+1 == 1+r == SimpleRatio(3,2)
    @test r-1 == SimpleRatio(-1,2)
    @test 1-r == r
    @test r+r2 == SimpleRatio(7,6)
    @test r-r2 == SimpleRatio(-1,6)
    @test r^2 == SimpleRatio(1,4)
    @test -r == SimpleRatio(-1,2)
    @test 0.2*r ≈ 0.1
    @test r == 0.5
    @test 0.5 == r

    r3 = SimpleRatio(7,3)
    @test r2+r3 === SimpleRatio(9,3)
    @test r2-r3 === SimpleRatio(-5,3)

    r8 = SimpleRatio{Int8}(1, 20)
    @test r8 + r8 == SimpleRatio(1, 10)

    @test_throws OverflowError -SimpleRatio(0x02,0x03)

    @test r + SimpleRatio(0x02,0x03) == SimpleRatio(7,6)

    @test SimpleRatio(11, 10) == 11//10
    @test 1//3 + SimpleRatio(1, 5) == 8//15

    @test isfinite(SimpleRatio(0,0)) == false
    @test isfinite(SimpleRatio(1,0)) == false
    @test isfinite(SimpleRatio(2,1)) == true

    @test SimpleRatio(5,3) * 0.035N0f8 == SimpleRatio{Int}(rationalize((5*0.035N0f8)/3))
    @test SimpleRatio(5,3) * 0.035N4f12 == SimpleRatio{Int}(rationalize((5*0.035N4f12)/3))
    @test SimpleRatio(5,3) * -0.03Q0f7 == SimpleRatio{Int}(rationalize((5.0*(-0.03Q0f7))/3))
    r = @inferred(SimpleRatio(0.75Q0f7))
    @test r == 3//4 && r isa SimpleRatio{Int16}

    # common_denominator
    @test common_denominator(SimpleRatio(2,7), SimpleRatio(3,11), SimpleRatio(-1,5)) ===
        (SimpleRatio(2*11*5,385), SimpleRatio(3*7*5,385), SimpleRatio(-1*7*11,385))
    @test common_denominator(SimpleRatio(5,12), SimpleRatio(4,15), SimpleRatio(-1,9)) ===
        (SimpleRatio(75,180), SimpleRatio(48,180), SimpleRatio(-20,180))
    @test_throws OverflowError common_denominator(SimpleRatio{Int8}(1, 20), SimpleRatio{Int8}(2, 21))
    @test common_denominator(SimpleRatio{Int8}(1, 20), SimpleRatio{Int8}(3, 20)) ===
        (SimpleRatio{Int8}(1, 20), SimpleRatio{Int8}(3, 20))

    @test isinteger(SimpleRatio(12, 6))
    @test isinteger(SimpleRatio(12, 1))
    @test isinteger(SimpleRatio(1, 1))
    @test isinteger(SimpleRatio(-1, 1))
    @test isinteger(SimpleRatio(-1, -1))
    @test isinteger(SimpleRatio(-10, -1))
    @test isinteger(SimpleRatio(0, -1))
    @test isinteger(SimpleRatio(0, 1))
    @test isinteger(SimpleRatio(9, 3))
    @test !isinteger(SimpleRatio(5, 3))
    @test !isinteger(SimpleRatio(5, -3))
    @test !isinteger(SimpleRatio(1, 2))
    @test !isinteger(SimpleRatio(1, -2))
    @test !isinteger(SimpleRatio(100, 99))
    @test !isinteger(SimpleRatio(9, 6))
end


# full copy
@testset "NoPow2Ratio" begin
    r = NoPow2Ratio(1,2)
    @test convert(Float64, r) === Float64(r) === 0.5
    @test convert(Float32, r) === Float32(r) === 0.5f0
    @test convert(BigFloat, r) == BigFloat(r) == BigFloat(1)/2

    r2 = NoPow2Ratio(2,3)
    @test r*r2 == NoPow2Ratio(2,6) == NoPow2Ratio(1,3)
    @test r2*3 == 3*r2 == 2
    @test r*false == false*r == 0
    @test r/r2 == NoPow2Ratio(3,4)
    @test r/2 == NoPow2Ratio(1,4)
    @test 2/r == 4
    @test 4 == 2/r
    @test r+1 == 1+r == NoPow2Ratio(3,2)
    @test r-1 == NoPow2Ratio(-1,2)
    @test 1-r == r
    @test r+r2 == NoPow2Ratio(7,6)
    @test r-r2 == NoPow2Ratio(-1,6)
    @test r^2 == NoPow2Ratio(1,4)
    @test -r == NoPow2Ratio(-1,2)
    @test 0.2*r ≈ 0.1
    @test r == 0.5
    @test 0.5 == r

    r3 = NoPow2Ratio(7,3)
    @test r2+r3 === NoPow2Ratio(27,9) # == NoPow2Ratio(9,3)
    @test r2-r3 === NoPow2Ratio(-15,9) # ==NoPow2Ratio(-5,3)

    r8 = NoPow2Ratio{Int8}(1, 20)
    @test_broken r8 + r8 == NoPow2Ratio(1, 10) # overflow in addition of Int8

    @test_throws OverflowError -NoPow2Ratio(0x02,0x03)

    @test r + NoPow2Ratio(0x02,0x03) == NoPow2Ratio(7,6)

    @test NoPow2Ratio(11, 10) == 11//10
    @test 1//3 + NoPow2Ratio(1, 5) == 8//15

    @test isfinite(NoPow2Ratio(0,0)) == false
    @test isfinite(NoPow2Ratio(1,0)) == false
    @test isfinite(NoPow2Ratio(2,1)) == true

    # FIXME FixedPoint conversion not implemented yet
    @test_skip NoPow2Ratio(5,3) * 0.035N0f8 == NoPow2Ratio{Int}(rationalize((5*0.035N0f8)/3))
    @test_skip NoPow2Ratio(5,3) * 0.035N4f12 == NoPow2Ratio{Int}(rationalize((5*0.035N4f12)/3))
    @test_skip NoPow2Ratio(5,3) * -0.03Q0f7 == NoPow2Ratio{Int}(rationalize((5.0*(-0.03Q0f7))/3))
    #r = @inferred(NoPow2Ratio(0.75Q0f7))
    @test_skip r == 3//4 && r isa NoPow2Ratio{Int16}

    # common_denominator
    @test common_denominator(NoPow2Ratio(2,7), NoPow2Ratio(3,11), NoPow2Ratio(-1,5)) ===
        (NoPow2Ratio(2*11*5,385), NoPow2Ratio(3*7*5,385), NoPow2Ratio(-1*7*11,385))
    @test common_denominator(NoPow2Ratio(5,12), NoPow2Ratio(4,15), NoPow2Ratio(-1,9)) ===
        (NoPow2Ratio(75,180), NoPow2Ratio(48,180), NoPow2Ratio(-20,180))
    @test_throws OverflowError common_denominator(NoPow2Ratio{Int8}(1, 20), NoPow2Ratio{Int8}(2, 21))
    @test common_denominator(NoPow2Ratio{Int8}(1, 20), NoPow2Ratio{Int8}(3, 20)) ===
        (NoPow2Ratio{Int8}(1, 20), NoPow2Ratio{Int8}(3, 20))

    @test isinteger(NoPow2Ratio(12, 6))
    @test isinteger(NoPow2Ratio(12, 1))
    @test isinteger(NoPow2Ratio(1, 1))
    @test isinteger(NoPow2Ratio(-1, 1))
    @test isinteger(NoPow2Ratio(-1, -1))
    @test isinteger(NoPow2Ratio(-10, -1))
    @test isinteger(NoPow2Ratio(0, -1))
    @test isinteger(NoPow2Ratio(0, 1))
    @test isinteger(NoPow2Ratio(9, 3))
    @test !isinteger(NoPow2Ratio(5, 3))
    @test !isinteger(NoPow2Ratio(5, -3))
    @test !isinteger(NoPow2Ratio(1, 2))
    @test !isinteger(NoPow2Ratio(1, -2))
    @test !isinteger(NoPow2Ratio(100, 99))
    @test !isinteger(NoPow2Ratio(9, 6))
end
