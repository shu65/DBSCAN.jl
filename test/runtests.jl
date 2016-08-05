using DBSCAN
using Base.Test

function distance(points)
    n = length(points)
    D = Matrix{Float64}(n, n)
    for p in 1:n, q in 1:n
        D[p,q] = norm(points[p] - points[q])
    end
    return D
end

@testset "dbscan" begin
    D = distance(vcat(
        [rand(2) * 0.1 + [-10, -10] for _ in 1:10],
        [rand(2) * 0.1 + [+10, +10] for _ in 1:10]))
    clusters = dbscan(D, 1.0, 3)
    @test length(clusters) == 2
    @test Set(clusters[1]) == Set(1:10)
    @test Set(clusters[2]) == Set(11:20)
end
