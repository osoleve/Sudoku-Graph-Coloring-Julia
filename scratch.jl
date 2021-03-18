include("SudokuGraph.jl")


s = get_random_puzzle(5, 550)
print(s)

solve!(s)

print(s)

new_puzzle()
