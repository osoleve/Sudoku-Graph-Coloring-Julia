include("SudokuGraph.jl")
include("PuzzleBuilder.jl")

@time s = SudokuGraph(3)

@assert length(s.edges) == 810 "Edges are wrong"
@assert length(s.nodes) == 81 "Nodes are wrong"

a,b = get_node.(((1,1),(1,2)), fill(s))

@time get_neighbors(a, s)

@assert get_saturation(a, s) == 0 "Saturation is broken"

set_value!(b, 3)

@assert get_saturation(a, s) == 1 "set_value! is broken"

@time set_possible_values!(a, s)

@assert 3 ∉ a.possible_values "set_possible_values! is broken"

print(s)

print(get_random_puzzle(3, 75))
