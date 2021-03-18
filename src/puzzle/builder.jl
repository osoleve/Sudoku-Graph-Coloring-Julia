include("../structure/graph.jl")
include("io.jl")
include("solver.jl")
include("vpt.jl")


function get_random_puzzle(puzzle_size::Int=3, filled::Int=33)
    if puzzle_size == 4
        graph = fast_4_sudoku()
    elseif puzzle_size == 5
        graph = fast_5_sudoku()
    else
        graph = SudokuGraph(puzzle_size)
        solve!(graph)
    end

    to_remove = puzzle_size^4 - filled

    for i in 1:to_remove
        node = rand(get_nonblank_nodes(graph))
        set_value!(node, 0)
        set_possible_values!(node, graph)
    end

    return graph
end

function derive_new_puzzle!(graph::SudokuGraph, steps::Int=1000)
    """
    Applies a sequence of validity-preserving transformations
    in order to create a different valid sudoku given a valid sudoku
    """
    for _ in 1:steps
        random_transformation!(graph)
    end

    return graph
end

function fast_4_sudoku(steps::Int=1000)
    include("src/data/4sudokus.jl")

    graph = load_puzzle(4, rand(base_puzzles))
    derive_new_puzzle!(graph, steps)

    return graph
end

function fast_5_sudoku(steps::Int=1000)
    include("src/data/5sudokus.jl")

    graph = load_puzzle(5, rand(base_puzzles))
    derive_new_puzzle!(graph, steps)

    return graph
end
