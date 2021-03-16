include("SudokuGraph.jl")
include("PuzzleSolver.jl")

using Lazy: any, @>, @>>
using StatsBase: sample

function load_puzzle(size::Int, values::Dict{Tuple{Int,Int},Int})::SudokuGraph
    s = SudokuGraph(size)

    for (coordinates, value) in values
        set_value!(get_node(coordinates, s), value)
    end

    return s
end

function load_puzzle_string(size::Int, board::String)::SudokuGraph
    s = SudokuGraph(size)
    vals = parse.(Int, split(board, ""))
    set_value!.(s.nodes, vals)
    return s
end

function get_random_puzzle(size::Int=3, filled::Int=33)
    graph = SudokuGraph(size)
    backtracking_coloring!(graph)

    to_remove = size^4 - filled

    for i in 1:to_remove
        node = rand(get_nonblank_nodes(graph))
        set_value!(node, 0)
        set_possible_values!(node, graph)
    end

    return graph
end
