include("SudokuGraph.jl")

using Lazy: any, @>, @>>
using StatsBase: sample

#WIP, can and will make impossible puzzles

function creates_impossibility(node::SudokuNode, value::Int, graph::SudokuGraph)::Bool
    # Incomplete
    neighbors = get_neighbors(node, graph)
    cells = get_cell.(fill(graph), 1:9)

    # Check if any require the value
    for neighbor in neighbors
        possible_values = get_possible_values(neighbor)
        if length(possible_values) == 1 && value in possible_values
            return true
        end
    end

    # Check if this blocks any cells
    for cell in cells
        # If value is in cell already, skip
        if value in get_value.(cell)
            continue
        end
        # Are there any non-neighboring cells that
        # can accept the value otherwise?
        unblocked = @>> begin
            cell
            filter(x -> value in get_possible_values(x))
            filter(x -> x ∉ neighbors)
            length
        end
        if unblocked == 0
            return true
        end
    end

    return false
end


function get_random_puzzle(size::Int, fill_pct::Int)::SudokuGraph
    sudoku = SudokuGraph(size)

    set_possible_values!.(sudoku.nodes, fill(sudoku))

    to_fill = Int(floor((size^4) * (fill_pct / 100)))

    i = 0

    while i < to_fill
        node = @> sudoku begin
            get_blank_nodes
            set_possible_values!.(fill(sudoku))
            rand(1)
            pop!
        end

        pval = rand(get_possible_values(node))

        if creates_impossibility(node, pval, sudoku)
            remove_possibility!(node, pval)
            continue
        else
            set_value!(node, pval)
            i += 1
        end
    end

    return sudoku
end
