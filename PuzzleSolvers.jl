include("SudokuGraph.jl")

function naive_coloring!(graph::SudokuGraph)::SudokuGraph
    while !is_solved(graph)
        naive_coloring_step!(graph)
    end

    return graph
end

function naive_coloring_step!(graph::SudokuGraph)::SudokuGraph
    nodes = get_blank_nodes(graph)

    saturations = get_saturation.(nodes, fill(graph))
    max_saturation = maximum(saturations)

    node_idxs = findall(x->x==max_saturation, saturations)

    node = nodes[rand(node_idxs)]
    set_value!(node, rand(get_possible_values(node, graph)))

    return graph
end
