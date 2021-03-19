# Validity-Preserving Transformations

include("../structure/graph.jl")

using Random: shuffle

function random_transformation!(graph::SudokuGraph)::SudokuGraph
    transformation_type = rand(("swap", "rotate", "relabel"))

    s = graph.puzzle_size

    if transformation_type == "rotate"
        graph = rotate!(graph)
    elseif transformation_type == "relabel"
        graph = relabel!(graph)
    else
        target_type = rand(("row", "column", "band", "stack"))
        targets = collect(1:s)
        popat!(targets, rand(1:s))
        graph = swap!(graph, target_type, targets)
    end
    return graph
end

function mirror!(graph::SudokuGraph)::SudokuGraph
    axis = rand([1,2])
    s = graph.puzzle_size^2
    for i in 1:s
        for j in 1:s÷2
            if axis == 1
                nodes = get_node.(((i,j),(i,s+1-j)), fill(graph))
            elseif axis == 2
                nodes = get_node.(((j,i),(s+1-j,i)), fill(graph))
            end
            x,y = get_value.(nodes)
            set_value!.(nodes, [y,x])
        end
    end

    return graph
end


function rotate!(graph::SudokuGraph)
    "Rotate the graph 270 degrees"
    for node in graph.nodes
        x, y = node.coordinates
        # Plus 1 to account for Julia being 1-indexed
        node.coordinates = y, (1 + graph.puzzle_size^2) - x
    end

    return graph
end

function relabel!(graph::SudokuGraph)::SudokuGraph
    "Randomly relabel the numbers in the graph"
    targets = shuffle(1:graph.puzzle_size^2)

    for node in graph.nodes
        if node.value != 0
            node.value = targets[node.value]
        end
    end

    return graph
end


function swap!(graph::SudokuGraph, target_type::String, targets::Vector{Int})::SudokuGraph
    "Swap two rows or columns within a band or stack, or two bands/stacks"
    s = graph.puzzle_size

    if target_type in ("row", "column")
        # Pick stack or band to update
        target_group = rand(1:s)

        # Calculate coordinates to update
        targets .= targets .+ (s * (target_group - 1))

        if target_type == "row"
            coord = 1
        else
            coord = 2
        end

        x = collect(filter(x->x.coordinates[coord]==targets[1], graph.nodes))
        y = collect(filter(x->x.coordinates[coord]==targets[2], graph.nodes))

        for (n1, n2) in zip(x, y)
            n1.value, n2.value = n2.value, n1.value
        end
    else
        # Swap band or stack (all rows or columns within)
        # Calculate groups to update
        groups = [collect(1:s) .+ (s * (targets[i] - 1)) for i in 1:2]

        if target_type == "band"
            coord = 1
        else
            coord = 2
        end

        # Swap all rows/columns between bands/stacks
        for (xs, ys) in zip(groups...)
            for (x, y) in zip(xs, ys)
                n1s = collect(filter(n->n.coordinates[coord]==x, graph.nodes))
                n2s = collect(filter(n->n.coordinates[coord]==y, graph.nodes))

                for (n1, n2) in zip(n1s, n2s)
                    n1.value, n2.value = n2.value, n1.value
                end
            end
        end
    end

    return graph
end
