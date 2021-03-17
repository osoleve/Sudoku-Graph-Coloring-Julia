include("SudokuGraph.jl")
include("PuzzleIO.jl")
include("PuzzleSolver.jl")
include("ValidityPreservingTransformations.jl")


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

function naive_fast_puzzle(puzzle_size::Int=3, filled::Int=33, guesses::Int=10)
    graph = SudokuGraph(puzzle_size)

    for _ in 1:guesses
        blanks = get_blank_nodes(graph)
        set_possible_values!.(blanks, fill(graph))
        node = rand(blanks)
        value = rand(get_possible_values(node))
        set_value!(node, value)
    end

    backtracking_coloring!(graph)

    to_remove = puzzle_size^4 - filled

    for i in 1:to_remove
        node = rand(get_nonblank_nodes(graph))
        set_value!(node, 0)
        set_possible_values!(node, graph)
    end

    return graph
end

function fast_4_sudoku(filled::Int=100, steps::Int=1000)
    include("4Sudokus.jl")

    graph = load_puzzle(4, rand(base_puzzles))
    randomly_transform!(graph, steps)

    to_remove = 4^4 - filled

    for i in 1:to_remove
        node = rand(get_nonblank_nodes(graph))
        set_value!(node, 0)
        set_possible_values!(node, graph)
    end

    return graph
end
