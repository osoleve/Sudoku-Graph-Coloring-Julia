# Sudoku Generator/Solver

Uses a homebrew graph to use graph coloring algorithms to generate and solve
sudokus.

`get_random_puzzle(s::Int=3, n::Int=33)` (where `s` is the Sudoku size and `n` is the number of
squares to fill in) is guaranteed to generate a valid puzzle, but not guaranteed to
generate a puzzle with a unique solution. Has been tested on sizes 3 and 4.  

- Generates 3-sudokus in under a second.
- Usually takes <30s to generate 4-sudokus from scratch
- Takes an indeterminate amount of time to create anything bigger (let me know
  if you manage to create one with it)

`fast_4_sudoku(n::Int=100, t::Int=1000)` (where `n` is the number of squares to fill in, and `t`
is the number of transformation steps) generates a 4-sudoku in under a second
for `t<=1000` by taking one of the pre-generated 4-sudokus and applying `t` random
validity-preserving transformations.

`solve!(graph::SudokuGraph)` returns `false` if no valid solution exists for the
 supplied puzzle.

For examples on how to format a puzzle for loading, check out `4Sudokus.jl` and
`PuzzleIO.jl`

2 and 3-sudokus have an extra, simplified input method using a string:

```julia
> g = load_puzzle_string(2, "4000104334100134");
> print(g)

4 1 | 3
    | 4 1
-----------
  4 | 1 3
  3 |   4
```
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

> @time g = fast_4_sudoku(100)

0.479907 seconds (2.22 M allocations: 144.140 MiB, 3.28% gc time)

> print(g)

            |  1          |             |  8 14
          2 |       14  4 |             |     6 15
            |             |  4    16    |        5
16       12 |     6  7    |    14  5  8 |        4
-----------------------------------------------------
 9    13  3 | 12    10    |    15    16 |  5     2  1
       7 15 |     5       |     8  1 14 |       12 13
12 14       |  4  1    15 | 13  5    10 |     8      
10          |  7    16    |       12  3 |  4 15    14
-----------------------------------------------------
            |    14     7 |     2       | 11  5 16
       5    |       11    |           4 |  9  2  6 10
   15     9 |             |           5 | 14       12
 3  2 12    |  5    15    |  8        9 |
-----------------------------------------------------
            | 11  2  5 16 | 12 10       | 15
       2    | 10          |       15 13 |
            |     7     1 |             |       13  5
 8          |    15  4    |  9        6 | 16
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

> g = SudokuGraph(4)
> print(g)

             |             |             |
             |             |             |
             |             |             |
             |             |             |
-----------------------------------------------------
             |             |             |
             |             |             |
             |             |             |
             |             |             |
-----------------------------------------------------
             |             |             |
             |             |             |
             |             |             |
             |             |             |
-----------------------------------------------------
             |             |             |
             |             |             |
             |             |             |
             |             |             |

> solve!(g)
> print(g)

16 12 14  3 | 10  6  2 11 |  1  8  4  7 | 13 15  5  9
 8  4 10  7 |  5 14  9  3 | 12 11 15 13 | 16  1  2  6
15  2 13  6 |  1  8  7  4 |  5 16  3  9 | 14 11 10 12
11  1  5  9 | 15 16 12 13 | 10 14  6  2 |  8  3  4  7
-----------------------------------------------------
14  5  7  2 | 13  3  6 10 | 15  9  8 12 |  1  4 16 11
 1  3 11 12 | 16  2  8  9 | 13 10  5  4 |  7 14  6 15
 4  9  6 15 | 14 12  5  7 |  3  1 11 16 | 10  2  8 13
13 10 16  8 | 11 15  4  1 |  6  7  2 14 | 12  5  9  3
-----------------------------------------------------
 7  6  3 10 |  9  1 16 15 |  2  5 13  8 |  4 12 11 14
 9 14 15  1 |  8  4 13  5 |  7  6 12 11 |  2 16  3 10
 5 16  2 11 | 12  7  3 14 |  9  4  1 10 |  6 13 15  8
12  8  4 13 |  2 10 11  6 | 16  3 14 15 |  5  9  7  1
-----------------------------------------------------
10 11  8  5 |  6 13 14  2 |  4 15  9  1 |  3  7 12 16
 2  7 12 16 |  3  9 15  8 | 14 13 10  5 | 11  6  1  4
 6 13  9  4 |  7 11  1 12 |  8  2 16  3 | 15 10 14  5
 3 15  1 14 |  4  5 10 16 | 11 12  7  6 |  9  8 13  2

```
