include("SudokuGraph.jl")
include("PuzzleBuilder.jl")
include("test_puzzle.jl")
include("PuzzleSolver.jl")

using BenchmarkTools

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

@benchmark get_random_puzzle($puzzle_size, 50)
@benchmark get_random_puzzle_fast($puzzle_size, 50, 10)

for i in 0:8
    print(i, ": ")
    @btime get_random_puzzle_fast(3, 81, $i)
    println()
end
