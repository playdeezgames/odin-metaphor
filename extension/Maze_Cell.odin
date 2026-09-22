package extension

import "base:runtime"

Maze_Cell :: struct($T: typeid) {
    neighbors : map[T]^Maze_Cell(T),
    doors: map[T]^Maze_Door
}

maze_cell_init :: proc(cell: ^Maze_Cell($T)) {
    cell.neighbors = make(map[T]^Maze_Cell(T))
    cell.doors = make(map[T]^Maze_Door)
}

maze_cell_destroy :: proc(cell: ^Maze_Cell($T)) {
    delete(cell.neighbors)
    delete(cell.doors)
}

maze_cell_has_neighbor :: proc(cell: ^Maze_Cell($T), direction: T) -> bool {
    return maze_cell_get_neighbor(cell, direction) != nil
}

maze_cell_set_neighbor :: proc(cell: ^Maze_Cell($T), direction:T, neighbor: ^Maze_Cell(T)) {
    cell.neighbors[direction] = neighbor
}

maze_cell_get_neighbor :: proc(cell: ^Maze_Cell($T), direction:T) -> ^Maze_Cell(T) {
    result, ok := cell.neighbors[direction]
    if ok {
        return result
    }
    return nil
}

maze_cell_get_door :: proc(cell: ^Maze_Cell($T), direction: T) -> ^Maze_Door {
    result, ok := cell.doors[direction]
    if ok {
        return result
    }
    return nil
}

maze_cell_set_door :: proc(cell: ^Maze_Cell($T), direction: T, door: ^Maze_Door) {
    cell.door[direction] = door
}

maze_cell_get_neighbors :: proc(cell: ^Maze_Cell($T), allocator: runtime.Allocator) -> map[^Maze_Cell(T)]struct{} {
    result := make(map[^Maze_Cell(T)]struct{}, allocator)
    for _, neighbor in cell.neighbors {
        result[neighbor]={}
    }
    return result
}

maze_cell_get_directions :: proc(cell: ^Maze_Cell($T)) -> [dynamic]T {
    result := make([dynamic]T)
    for direction, _ in cell.neighbors {
        append(&result, direction)
    }
    return result
}

maze_cell_reset :: proc(cell: ^Maze_Cell($T)) {
    for _, door in cell.doors {
        door.open = false
    }
}

maze_cell_get_open_door_count :: proc(cell: ^Maze_Cell($T)) -> int {
    result := 0
    for _, door in cell.doors {
        if door.open {
            result += 1
        }
    }
    return result
}
