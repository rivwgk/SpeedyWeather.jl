@testset "Create and compare particles" begin
    @test Particle() == Particle(0,0) == Particle(0,0,0)
    @test Particle(0,0,0) == zero(Particle) == zero(Particle{Float32}) == zero(Particle{Float32}())
    @test Particle() == Particle(0.0,0.0) == Particle(0f0,0f0,0.0) == Particle(0,Float16(0))
    @test Particle{Float32}() == Particle{Float32,true}()
    @test Particle{Float32}() != Particle{Float32,false}()
    @test deactivate(Particle()) != Particle()
    @test activate(Particle()) == Particle()
    @test Particle(1,2) != Particle(2,1)
    @test Particle(lon=1,lat=2) == Particle(lat=2,lon=1.0)
    @test Particle(lon=1,lat=2,σ=0) == Particle(lat=2,lon=1.0)
    @test Particle(lon=1,lat=2,σ=3.0) == Particle(1,2,3)
    @test Particle{Float16}(lon=1,lat=2) == Particle{Float32}(lat=2,lon=1.0)
    @test Particle{Float16}(lon=1,lat=2,σ=0) == Particle{Float32}(lat=2,lon=1.0)
    @test Particle{Float16}(lon=1,lat=2,σ=3.0) == Particle{Float32}(1,2,3)
    @test active(Particle(1,2,3))
    @test ~active(deactivate(Particle(1,2,3)))
    @test ~active(Particle{Float64,false}(1,2,3))
    @test Particle(lon=0,lat=90) == Particle(lon=10,lat=90)
    @test Particle(lon=0,lat=-90) == Particle(lon=10,lat=-90)
    @test Particle(lon=0,lat=-90) != Particle(lon=10,lat=90)
end

@testset "Modulo particles" begin
    for NF in (Float16,Float32,Float64)
        for n in 1:100
            lat = 90 + n*eps(NF)
            p = Particle(lon = 0, lat = lat)
            @test mod(p).lat <= 90
            @test SpeedyWeather.ismod(mod(p))
            
            lat = -90 - n*eps(NF)
            p = Particle(lon = 0, lat = lat)
            @test mod(Particle(lon = 0, lat = lat)).lat >= -90
            @test SpeedyWeather.ismod(mod(p))

            lat = 1000*randn(NF)
            lon = 1000*randn(NF)
            p = Particle(;lon,lat)
            @test SpeedyWeather.ismod(mod(p))
        end
    end

    for NF in (Float32,Float64)
        for n in 1:100
            # move particles 1-4x around the globe
            for k in 1:4
                p = rand(Particle{NF})
                
                # positive
                a = 0.1
                r = sqrt(sqrt(eps(NF)))
                @test p ≈ mod(Particle(lon = p.lon + k*360, lat = p.lat, σ=p.σ)) atol = a rtol = r
                @test p ≈ mod(Particle(lon = p.lon, lat = p.lat + k*360, σ=p.σ)) atol = a rtol = r
                @test p ≈ mod(Particle(lon = p.lon + k*360, lat = p.lat + k*360, σ=p.σ)) atol = a rtol = r

                # negative
                @test p ≈ mod(Particle(lon = p.lon - k*360, lat = p.lat, σ=p.σ)) atol = a rtol = r
                @test p ≈ mod(Particle(lon = p.lon, lat = p.lat - k*360, σ=p.σ)) atol = a rtol = r
                @test p ≈ mod(Particle(lon = p.lon - k*360, lat = p.lat - k*360, σ=p.σ)) atol = a rtol = r
            end
        end
    end
end

@testset "Random particles" begin
    @test rand(Particle) isa Particle
    @test rand(Particle{Float16}) isa Particle
    @test rand(Particle{Float64,false}) isa Particle

    @test rand(Particle,5) isa Vector{Particle}
    @test rand(Particle{Float32},5) isa Vector{Particle{Float32}}
    @test rand(Particle{Float32,false},5) isa Vector{Particle{Float32,false}}
end

@testset "Move particles" begin
    for NF in (Float32, Float64)
        
        p = Particle{NF}(lon=-350,lat=0)
        @test mod(p) == Particle{NF}(lon=10,lat=0)        
        
        p = Particle{NF}(lon=370,lat=0)
        @test mod(p) == Particle{NF}(lon=10,lat=0)

        p = rand(Particle{NF})
        @test p == mod(p)
        @test move(p,360,180) != p
        @test mod(move(p,360,0)).lon ≈ p.lon

        p = Particle{NF}(lon=10,lat=89)
        @test mod(move(p,0,3)) == Particle{NF}(lon=190,lat=88)

        p = Particle{NF}(lon=350,lat=89)
        @test mod(move(p,12,0)) == Particle{NF}(lon=2,lat=89)

        p = Particle{NF}(lon=0,lat=-80)
        @test mod(move(p,0,-15)) == Particle{NF}(lon=180,lat=-85)

        p = Particle{NF}(lon=0,lat=-89)
        @test mod(move(p,-1,-4)) == Particle{NF}(lon=179,lat=-87)
    end
end