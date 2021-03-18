include("src/puzzle/builder.jl")
include("src/puzzle/solver.jl")
include("src/structure/graph.jl")

function new_puzzle(puzzle_size::Int=3, filled::Int=0)
    if filled == 0
        filled = puzzle_size^4 - puzzle_size^3
    end

    print(get_random_puzzle(puzzle_size, filled))
end
