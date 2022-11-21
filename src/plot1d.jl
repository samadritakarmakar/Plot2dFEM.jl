#using RapidFEM, Plots
#pyplot()
#pgfplotsx()
function plotElements!(p1::Plots.Plot, solution::AbstractVector{Float64}, colour::String, mesh::Mesh, volAttrib::Tuple{Int64, Int64}, 
    usedDims::StepRange, i)
    for element ∈ mesh.Elements[volAttrib]
        coordArray = getCoordArray(mesh, element)[usedDims, :]
        plot!(p1, coordArray', solution[element.nodeTags], label = "", linecolor = colour)
    end
    return p1
end

function plot1d(solution::Vector{Float64}, mesh::Mesh, activeDims::Vector{Int64})
    dimRange = RapidFEM.createDimRange()
    usedDims = dimRange[activeDims]
    
    nodesVector = zeros(length(mesh.Nodes))
    i = 1
    for nodeKey ∈ sort(collect(keys(mesh.Nodes)))
        nodesVector[i] = mesh.Nodes[nodeKey][usedDims][1]
        i += 1
    end
    #start with a scatter plot1d
    p1 = scatter(nodesVector, solution)
end


function plot1d(solutions::Vector{Vector{Float64}}, labels::Array{String}, colours::Array{String}, mesh::Mesh, volAttrib::Tuple{Int64, Int64}, activeDims::Vector{Int64})
    dimRange = RapidFEM.createDimRange()
    usedDims = dimRange[activeDims]
    
    nodesVector = zeros(length(mesh.Nodes))
    i = 1
    for nodeKey ∈ sort(collect(keys(mesh.Nodes)))
        nodesVector[i] = mesh.Nodes[nodeKey][usedDims][1]
        i += 1
    end
    #start with a scatter plot1d
    p1 = scatter(nodesVector, solutions[1], markercolour = colours[1], label = labels[1], legend = :topleft)
    plotElements!(p1, solutions[1], colours[1], mesh, volAttrib, usedDims, 1)
    for i ∈ 2:length(solutions)
        scatter!(p1, nodesVector, solutions[i], markercolour = colours[i], label = labels[i])
        plotElements!(p1, solutions[i], colours[i], mesh, volAttrib, usedDims , i)
    end
    display(p1)
    return p1
end
