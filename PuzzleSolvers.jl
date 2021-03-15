include("SudokuGraph.jl")

function is_solved(graph::SudokuGraph)::Bool
    return length(get_blank_nodes(graph)) == 0
end

function naive_coloring_step!(graph::SudokuGraph)::SudokuGraph
    nodes = get_blank_nodes(graph)

    saturations = get_saturation.(nodes, fill(graph))
    max_saturation = maximum(saturations)

    node_idxs = findall(x->x==max_saturation, saturations)

    node = nodes[rand(node_idxs)]
    value = rand(get_possible_values(node, graph))
    set_value!(node, value)

    return graph
end

function naive_coloring!(graph::SudokuGraph)::SudokuGraph
    while !is_solved(graph)
        naive_coloring_step!(graph)
    end

    return graph
end

function naive_coloring_partial!(graph::SudokuGraph, steps::Int)::SudokuGraph
    for _ in 1:steps
        naive_coloring_step!(graph)
    end
    return graph
end
