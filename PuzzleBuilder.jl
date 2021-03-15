include("SudokuGraph.jl")
include("PuzzleSolvers.jl")

using Lazy: any, @>, @>>
using StatsBase: sample

function load_puzzle(size::Int, values::Dict{Tuple{Int,Int},Int})::SudokuGraph
    s = SudokuGraph(size)

    for (coordinates, value) in values
        set_value!(get_node(coordinates, s), value)
    end

    return s
end

function get_random_puzzle(size::Int, filled::Int)::SudokuGraph
    graph = SudokuGraph(size)

    done = 0

    while !Bool(done)
        try
            graph = naive_coloring!(graph)
            done = 1
        catch ArgumentError
            graph = SudokuGraph(size)
            done = 0
        end
    end

    to_remove = size^4 - filled

    for i in 1:to_remove
        node = rand(get_nonblank_nodes(graph))
        set_value!(node, 0)
    end

    return graph
end
