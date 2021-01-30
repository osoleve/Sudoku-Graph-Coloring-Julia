using Lazy: all

mutable struct SudokuNode
    coordinates::Tuple{Int,Int}
    cell::Int
    value::Int

    possible_values::Vector{Int}

    function SudokuNode(coordinates::Tuple{Int,Int})
        return new(coordinates, 0, 0, [])
    end
end

function get_coordinates(node::SudokuNode)::Tuple{Int,Int,Int}
    return (node.coordinates..., node.cell)
end

function get_possible_values(node::SudokuNode)::Vector{Int}
    return node.possible_values
end

function get_value(node::SudokuNode)::Int
    return node.value
end

function set_value!(node::SudokuNode, value::Int)::SudokuNode
    node.value = value
    return node
end

function Base.isequal(a::SudokuNode, b::SudokuNode)::Bool
    a, b = get_coordinates.((a, b))
    return all(a .== b)
end

function set_cell!(node::SudokuNode, size::Int)::SudokuNode
    row, col = node.coordinates .- 1
    node.cell = 1 + floor(((col // size) + row) - (row % size))
    return node
end

function remove_possibility!(node::SudokuNode, value::Int)::SudokuNode
    node.possible_values = [val for val in node.possible_values if val != value]
    return node
end
