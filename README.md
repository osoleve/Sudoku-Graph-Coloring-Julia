# Sudoku Generator/Solver

Uses a graph built from scratch to use graph coloring to generate and solve sudokus. Finally guaranteed to successfully generate a valid puzzle every time.

`solve!(graph)` returns `false` if no valid solution exists for the supplied puzzle.

Takes a little to generate puzzles larger than 3-sudokus.


## Generating a puzzle

```julia
> get_random_puzzle(3, 33)

4     | 9     |
9 2   |   6 3 | 4
      |       | 6
---------------------
8   2 |   3 9 | 7 4 1
      |   8 1 |   2
3 1   |     7 |   5
---------------------
      | 2 1   | 9 8
9     |   7   | 5 3
2   7 |     5 |      
```

## Solving a puzzle

```julia
> g = get_random_puzzle(3, 25)
> print(g)

2 3   | 4   5 |
6     |       | 9   4
    4 | 7     | 8
---------------------
      |   5   | 7
      | 9     |
      |     8 |   1 3
---------------------
      | 1   6 |      
  4 2 | 8 3   | 6   1
  6   |       |

> solve!(g)
> print(g)

2 3 8 | 4 9 5 | 1 6 7
6 7 5 | 3 8 1 | 9 2 4
9 1 4 | 7 6 2 | 8 3 5
---------------------
4 8 1 | 6 5 3 | 7 9 2
3 2 7 | 9 1 4 | 5 8 6
5 9 6 | 2 7 8 | 4 1 3
---------------------
8 5 3 | 1 4 6 | 2 7 9
7 4 2 | 8 3 9 | 6 5 1
1 6 9 | 5 2 7 | 3 4 8
```
