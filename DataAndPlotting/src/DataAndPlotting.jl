module DataAndPlotting

using CSV
using HDF5
using Plots
# wave parameter
const ki = 2
const kj = 3

# Grid size
const ni = 30
const nj = 20

function index2coord(i , ni)
    @assert ni > 1
    @assert 1 <= i <= ni
    (i-1) / (ni-1)
end

# Set up standing wave
export initialize
function initialize()
    arr = zeros(Float64 , ni , nj)
    for j in 1:nj, i in 1:ni
        x = index2coord(i , ni)
        y = index2coord(j , nj)
        arr[i,j] = sin(2*π*ki*x) * sin(2*π*kj*y)
    end
    return arr
end

# Write data to file
export output
function output(arr::Array{Float64,2}, filename::String)
    h5write(filename, "data", arr)
end

# read file
export input
function input(filename::String)
    arr = h5read(filename, "data")
end


# Create a beautiful Plot
"not working"
export makeplot
function makeplot(arr::Array{Float64,2})
    x = range(0 , stop = 1 , length = ni)
    y = range(0 , stop = 1 , length = nj)
    p = plot(x, y, arr, st=[:surface, :contourf])
end

end # module
