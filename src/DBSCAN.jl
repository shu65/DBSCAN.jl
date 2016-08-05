module DBSCAN

export dbscan

#=
NOTE: These pseudocodes were derived from https://en.wikipedia.org/wiki/DBSCAN.

DBSCAN(D, eps, MinPts) {
   C = 0
   for each point P in dataset D {
      if P is visited
         continue next point
      mark P as visited
      NeighborPts = regionQuery(P, eps)
      if sizeof(NeighborPts) < MinPts
         mark P as NOISE
      else {
         C = next cluster
         expandCluster(P, NeighborPts, C, eps, MinPts)
      }
   }
}
=#

function dbscan(D, eps, minpts)
    clusters = []
    n = size(D, 1)
    visited = falses(n)
    noise = falses(n)
    for p in 1:n
        if visited[p]
            continue
        end
        visited[p] = true
        neighbors = region_query(D, p, eps)
        if length(neighbors) < minpts
            noise[p] = true
        else
            push!(clusters, [])
            expand_cluster!(clusters, neighbors, visited, D, p, eps, minpts)
        end
    end
    return clusters
end

#=
expandCluster(P, NeighborPts, C, eps, MinPts) {
   add P to cluster C
   for each point P' in NeighborPts { 
      if P' is not visited {
         mark P' as visited
         NeighborPts' = regionQuery(P', eps)
         if sizeof(NeighborPts') >= MinPts
            NeighborPts = NeighborPts joined with NeighborPts'
      }
      if P' is not yet member of any cluster
         add P' to cluster C
   }
}
=#

function expand_cluster!(clusters, neighbors, visited, D, p, eps, minpts)
    push!(clusters[end], p)
    for p′ in neighbors
        if !visited[p′]
            visited[p′] = true
            neighbors′ = region_query(D, p′, eps)
            if length(neighbors′) >= minpts
                append!(neighbors, neighbors′)
            end
        end
        if !any(c -> p′ in c, clusters)
            push!(clusters[end], p′)
        end
    end
end

#=
regionQuery(P, eps)
   return all points within P's eps-neighborhood (including P)
=#

function region_query(D, p, eps)
    neighbors = []
    for p′ in 1:size(D, 1)
        if D[p,p′] < eps
            push!(neighbors, p′)
        end
    end
    return neighbors
end

end # module
