module Example2018

export Point
struct Point{T}
    x::T
    y::T
end

function Base. +(p::Point, q::Point)
    Point(p.x + q.x, p.y + q.y)
end



export MPoint
mutable struct MPoint{T}
    x::T
    y::T
end

###############################################################################


#### defined polynomial type
export Polynomial
struct Polynomial{T}
    coeffs::Vector{T}
end

# edit base function for type polynomial

function Base. +(p::Polynomial, q::Polynomial)
    l = max(length(p.coeffs), length(q.coeffs))
    rcoeffs = zeros(eltype(p.coeffs),l)
    for (i,c) in enumerate(p.coeffs)
        rcoeffs[i] += c
    end
    for (i,c) in enumerate(q.coeffs)
        rcoeffs[i] += c
    end
    Polynomial(rcoeffs)
end


function Base. *(a, p::Polynomial)
    Polynomial(map(x->a*x, p.coeffs))
end
Base. *(p::Polynomial, a) = a*p


function Base. -(p::Polynomial)
    (-1) * p
end


function Base. -(p::Polynomial,q::Polynomial)
    p + (-q)
end


function Base. ==(p::Polynomial,q::Polynomial)
    d = p - q
    #all(c -> c==0, d.coeffs)
    # or
    all(d.coeffs .== 0)
end


##### function on Polynomial
export evaluate
function evaluate(p::Polynomial, x)
    sum(c * x^(i-1) for (i,c) in enumerate(p.coeffs))
end

export deriv
function deriv(p::Polynomial)
    Polynomial([(i-1) * c for (i,c) in enumerate(p.coeffs)][2:end])
end


#### play with package

# ApproxFun package
# ForwardDiff package
# ReverseDiff

# Rewrite.jl julia
# JuliaGraphs : not working with 1.0 for now

# BenchmarkTools
# check profile stuff for performance

# PyCall call python package into Julia
# Interact: have interacting stuff in Julia

# see package for
# how to store the data ? : CSV : nice but not super efficient
#                            HDF5 file, see package

# FunctionalCollections package
#
end
