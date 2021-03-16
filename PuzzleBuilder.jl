include("SudokuGraph.jl")
include("PuzzleSolver.jl")

function load_puzzle(puzzle_size::Int, values::Dict{Tuple{Int,Int},Int})::SudokuGraph
    s = SudokuGraph(puzzle_size)

    for (coordinates, value) in values
        set_value!(get_node(coordinates, s), value)
    end

    return s
end

function load_puzzle_string(puzzle_size::Int, board::String)::SudokuGraph
    s = SudokuGraph(puzzle_size)
    vals = parse.(Int, split(board, ""))
    set_value!.(s.nodes, vals)
    return s
end

function get_random_puzzle(puzzle_size::Int=3, filled::Int=33)
    graph = SudokuGraph(puzzle_size)
    backtracking_coloring!(graph)

    to_remove = puzzle_size^4 - filled

    for i in 1:to_remove
        node = rand(get_nonblank_nodes(graph))
        set_value!(node, 0)
        set_possible_values!(node, graph)
    end

    return graph
end
