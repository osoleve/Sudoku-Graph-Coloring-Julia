include("SudokuGraph.jl")

function derive_new_puzzle!(graph::SudokuGraph, steps::Int=1000)
    """
    Applies a sequence of validity preserving transformations
    in order to create a different valid sudoku given a valid sudoku
    """
    for _ in 1:steps
        random_transformation!(graph)
    end

    return graph
end

function random_transformation!(graph::SudokuGraph)::SudokuGraph
    transformation_type = rand(("swap", "rotate"))

    s = graph.puzzle_size

    if transformation_type == "rotate"
        graph = rotate!(graph)
    else
        target_type = rand(("row", "column", "band", "stack"))
        targets = collect(1:s)
        popat!(targets, rand(1:s))
        graph = swap!(graph, target_type, targets)
    end
    return graph
end

function rotate!(graph::SudokuGraph)
    for node in graph.nodes
        x, y = node.coordinates
        # Plus 1 to account for Julia being 1-indexed
        node.coordinates = y, (1 + graph.puzzle_size^2) - x
    end

    return graph
end

function swap!(graph::SudokuGraph, target_type::String, targets::Vector{Int})::SudokuGraph
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
