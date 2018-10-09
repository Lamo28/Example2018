module MonteCarloFun

"
arxiv doc :     1008.4686
                1205.4446

plan:
        1) Fitting a model to data
                Fitting a straight line
                magic of Gaussian

"

#2018_10_05
#fitting a straight line

using Plots
using LinearAlgebra

x = [1., 2., 3., 4.]
y = [14, 26, 37, 43]
sigma = [1, 1, 2, 2]

plot(x, y, seriestype=:scatter, yerr=sigma, legend=false)

Y=y
N = length(Y)
A = zeros(N,2)

A[:,1] .= 1.;
A[:,2] .= x;


W = Diagonal(1. ./ sigma.^2)

MB1 = A \ Y
MB2 = (sqrt(W)*A) \ (sqrt(W)*Y)



plot(x, y, seriestype=:scatter, yerr=sigma, legend=:topleft)
plot!(x, A * MB1, label="Unweighted")
plot!(x, A * MB2, label="Weighted")

C = inv(A' * W * A)

dMB = randn((100,2)) * sqrt(C)

Angle = collect(range(0,stop=2π,length=100))
xa = [sin.(Angle) cos.(Angle)]
cMB = xa * sqrt(C)

plot([MB1[1]], [MB1[2]], seriestype=:scatter, label="Unweighted",xlabel="b", ylabel="m")
plot!([MB2[1]], [MB2[2]], seriestype=:scatter, label="Weighted",xlabel="b", ylabel="m")
plot!(MB2[1] .+ dMB[:,1], MB2[2] .+ dMB[:,2], seriestype=:scatter, label="Weighted")
plot!(MB2[1] .+ cMB[:,1], MB2[2] .+ cMB[:,2], seriestype=:scatter, label="Weighted")

plot(x, y, seriestype=:scatter, yerr=sigma, legend=:topleft)
plot!(x, A * MB2, line=(:blue, 1, 3), label="Weighted")
for i in 1:50
    dmb = MB2 + dMB[i,:]
    plot!(x, A * dmb, label= "" , line=(:black, 0.2, 2))
end
plot!()

function line_log_likehood(x,y,sigma,m,b)
    return -0.5 * sum(@. (y -(m*x+b))^2 / sigma^2)
end

bbest,mbest = MB2
line_log_likehood(x,y,sigma,mbest,bbest)

function line_lnl(b,m)
    return line_log_likehood(x, y, sigma, m, b)
end

function make_line_lnl_function(x,y,sigma)
    function f(m,b)
        return line_log_likehood(x,y,sigma,m,b)
    end
    return f
end

LineLnl = make_line_lnl_function(x,y,sigma)
LineLnl(mbest,bbest)




end # module
