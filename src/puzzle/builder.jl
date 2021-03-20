include("../structure/graph.jl")
include("io.jl")
include("solver.jl")
include("vpt.jl")


function get_random_puzzle(puzzle_size::Int=3, filled::Int=0)
    if filled == 0
        filled = puzzle_size^4 - puzzle_size^3
    end

    if puzzle_size == 1
        throw("There is no size-1 Sudoku")
    elseif puzzle_size < 4
        graph = SudokuGraph(puzzle_size)
        solve!(graph)
    elseif 4 <= puzzle_size <= 7
        graph = fast_load(puzzle_size)
    else
        graph = SudokuGraph(puzzle_size)
        s = puzzle_size
        vals = []
        _range = collect(1:s^2)
        for i in 1:s
            for j in 1:s
                append!(vals, _range)
                _range = circshift(_range, -s)
            end
            _range = circshift(_range, -1)
        end
        for (node, value) in zip(graph.nodes, vals)
            set_value!(node,value)
        end
        graph = derive_new_puzzle!(graph, 100)
    end

    to_remove = puzzle_size^4 - filled

    for i in 1:to_remove÷2
        node = rand(get_nonblank_nodes(graph))
        coords = node.coordinates
        set_value!(node, 0)
        set_possible_values!(node, graph)
        coords = coords[end:-1:1]
        node = get_node(coords, graph)
        set_value!(node, 0)
        set_possible_values!(node, graph)
    end

    return graph
end

function derive_new_puzzle!(graph::SudokuGraph, steps::Int=50)
    """
    Applies a sequence of validity-preserving transformations
    in order to create a different valid sudoku given a valid sudoku
    """
    for _ in 1:steps
        random_transformation!(graph)
    end

    return graph
end

function fast_load(puzzle_size::Int, transformation_steps::Int=50)
    fname = string("src/data/",puzzle_size,"sudokus.jl")
    include(fname)

    graph = load_puzzle(puzzle_size, rand(base_puzzles))
    derive_new_puzzle!(graph, transformation_steps)

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
