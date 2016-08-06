# DBSCAN

[![Build Status](https://travis-ci.org/bicycle1885/DBSCAN.jl.svg?branch=master)](https://travis-ci.org/bicycle1885/DBSCAN.jl)

[![Coverage Status](https://coveralls.io/repos/bicycle1885/DBSCAN.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/bicycle1885/DBSCAN.jl?branch=master)

[![codecov.io](http://codecov.io/github/bicycle1885/DBSCAN.jl/coverage.svg?branch=master)](http://codecov.io/github/bicycle1885/DBSCAN.jl?branch=master)

Density-based spatial clustering of applications with noise (or DBSCAN) is a
density-based clustering algorithm invented by Ester, *et al.* (1996).

Ester, Martin, et al. "A density-based algorithm for discovering clusters in
large spatial databases with noise." Kdd. Vol. 96. No. 34. 1996.

NOTE: This package was developed for the pedagogical purpose of a lecture and is
NOT intended to be used in actual applications.


## Example

```julia
# generate two clusters
n_cluster1 = 100
n_cluster2 = 100
n_noise = 10
n_total = n_cluster1 + n_cluster2 + n_noise

points = []
append!(points, [randn(2) + [-2.0, -2.0] for _ in 1:n_cluster1])
append!(points, [randn(2) + [+2.0, +2.0] for _ in 1:n_cluster2])
append!(points, [randn(2) * 3 for _ in 1:n_noise])
shuffle!(points)

# make a distance matrix
D = Matrix{Float64}(n_total, n_total)
for p in 1:n_total, q in 1:n_total
    D[p,q] = norm(points[p] - points[q])
end


using DBSCAN

clusters = dbscan(D, 1.0, 5)
```
