include("SudokuGraph.jl")

function is_solved(graph::SudokuGraph)::Bool
    return length(get_blank_nodes(graph)) == 0
end

function backtracking_coloring!(graph::SudokuGraph)::Bool
    if is_solved(graph)
        return true
    end

    nodes = get_blank_nodes(graph)
    set_possible_values!.(nodes, fill(graph))

    saturations = get_saturation.(nodes, fill(graph))
    max_saturation = maximum(saturations)

    node_idxs = findall(x -> x == max_saturation, saturations)

    node = nodes[rand(node_idxs)]

    for value in get_possible_values(node)
        set_value!(node, value)
        if backtracking_coloring!(graph)
            return true
        end
        unset_value!(node, graph)
    end

    return false
end

solve! = backtracking_coloring!
