include("SudokuGraph.jl")

function randomly_transform!(graph::SudokuGraph, steps::Int=1000)
    """
    Applies a sequence of validity preserving transformations
    in order to create a different valid sudoku given a valid sudoku
    """
    for _ in 1:steps
        random_rearrange_step!(graph)
    end

    return graph
end

function random_rearrange_step!(graph::SudokuGraph)::SudokuGraph
    target_type = rand(("row", "band", "column", "stack"))

    s = graph.puzzle_size

    if target_type in ("row", "column")
        target_group = rand(1:s)
        targets = collect(1:s)
        popat!(targets, rand(1:s))
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
        targets = collect(1:s)
        popat!(targets, rand(1:s))

        groups = [collect(1:s) .+ (s * (targets[i] - 1)) for i in 1:2]

        if target_type == "band"
            coord = 1
        else
            coord = 2
        end

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
