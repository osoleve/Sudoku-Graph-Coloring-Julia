include("../structure/graph.jl")

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

function puzzle_to_string(graph::SudokuGraph)::String
    return join(string.(get_value.(graph.nodes)))
end

function puzzle_to_dict(graph::SudokuGraph)::Dict{Tuple{Int,Int},Int}
    return Dict(node.coordinates=>node.value for node in graph.nodes)
end

function Base.print(graph::SudokuGraph)
    function format_value(value::Int, maxwidth::Int)::String
        padding = maxwidth - length(string(value))

        if value == 0
            value = " "
        else
            value = string(value)
        end

        return lpad(value, padding)
    end

    println()
    maxwidth = length(string(graph.puzzle_size^2))+1
    width = graph.puzzle_size^2
    for i in 1:width
        for j in 1:width
            @> begin
                get_node((i, j), graph)
                get_value
                format_value(maxwidth)
                string(j % graph.puzzle_size == 0 && j != width ? " |" : "")
                string(j == width ? "\n" : " ")
                print
            end
        end
        if i % graph.puzzle_size == 0 && i != width
            println(repeat('-', graph.puzzle_size + maxwidth * graph.puzzle_size^2 + (graph.puzzle_size % 2 == 0)))
        end
    end
    println()
end
