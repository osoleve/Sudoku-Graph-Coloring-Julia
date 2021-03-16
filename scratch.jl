include("SudokuGraph.jl")
include("PuzzleBuilder.jl")
include("test_puzzle.jl")
include("PuzzleSolver.jl")

print(load_puzzle(test_size, test_value_dict))
print(load_puzzle_string(test_size, test_string))

g = load_puzzle(test_size, test_value_dict)
print(g)
@time solve!(g)
print(g)

g = SudokuGraph(3)
print(g)
@time solve!(g)
print(g)

g = SudokuGraph(4)
print(g)
@time solve!(g)
print(g)

puzzle_size = 3
@time print(get_random_puzzle(puzzle_size, puzzle_size^4))
