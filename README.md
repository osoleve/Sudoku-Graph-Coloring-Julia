# Sudoku Generator/Solver

Uses a graph built from scratch to use graph coloring to solve sudokus.

Call `get_random_puzzle(s, n)` to create a random puzzle, where s is the size of the puzzle you want and n is how many squares you want filled in.
Defaults to s=3, n=33.

There's an example puzzle in test_puzzle.jl that shows how to format custom puzzles.
