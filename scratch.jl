include("SudokuGraph.jl")
include("PuzzleBuilder.jl")
include("test_puzzle.jl")
include("PuzzleSolver.jl")

print(load_puzzle(test_size, test_value_dict))
print(load_puzzle_string(test_size, test_value_str))

print(get_random_puzzle(2, 6))

g = get_random_puzzle(3, 1)
print(g)
@time backtracking_coloring!(g)
print(g)

g = SudokuGraph(3)
print(g)
@time solve!(g)
print(g)
