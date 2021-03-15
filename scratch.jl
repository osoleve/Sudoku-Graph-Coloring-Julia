include("SudokuGraph.jl")
include("PuzzleBuilder.jl")
include("test_puzzle.jl")
include("PuzzleSolvers.jl")

@time s = SudokuGraph(3)

@assert length(s.edges) == 810 "Edges are wrong"
@assert length(s.nodes) == 81 "Nodes are wrong"

a,b = get_node.(((1,1),(7,2)), fill(s))

@time get_neighbors(a, s)

@assert get_saturation(a, s) == 0 "Saturation is broken"

set_value!(a, 9)
set_value!(b, 3)

@time set_possible_values!(a, s)

print(s)

get_node((1,1), s)

print(load_puzzle(test_size, test_value_dict))
@time print(naive_coloring(load_puzzle(test_size, test_value_dict)))

print(load_puzzle(test_size, test_value_dict))
print(naive_coloring_step!(load_puzzle(test_size, test_value_dict)))

print(naive_coloring!(SudokuGraph(3)))

print(naive_coloring_partial!(SudokuGraph(3), 20))

print(get_random_puzzle(3, 40))
print(get_random_puzzle())
