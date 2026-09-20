package extension

Maze :: struct($T: typeid) {
    columns: int,
    rows: int,
    cells: [dynamic]Maze_Cell(T),
    doors: [dynamic]Maze_Door
}

maze_init :: proc(maze: ^Maze($T), columns, rows: int, directions: map[T]Maze_Direction(T)) {
    maze.columns = columns
    maze.rows = rows
    maze.cells = make([dynamic]Maze_Cell(T), 0, columns * rows)
    maze.doors = make([dynamic]Maze_Door) //TODO: get an estimate!
    for index in 0..<columns*rows {
        append(&maze.cells, {})
        maze_cell_init(&maze.cells[index])
    }
    for column in 0..<columns {
        for row in 0..<rows {
            cell:= maze_get_cell(maze, column, row)
            for direction, maze_direction in directions {
                if !maze_cell_has_neighbor(cell, direction) {
                    next_column = column + maze_direction.delta_x
                    next_row = row + maze_direction.delta_y
                    next_cell = maze_get_cell(maze, next_column, next_row)
                    if next_cell != nil {
                        maze_cell_set_neighbor(cell, direction, next_cell)
                        maze_cell_set_neighbor(cell, maze_direction.opposite)
                        append(&maze.doors, {})
                        door:= maze.doors[len(maze.doors)-1]
                        maze_cell_set_door(cell, direction, door)
                        maze_cell_set_door(next_cell, maze_direction.opposite, door)
                    }
                }
            }
        }
    }
}

maze_destroy :: proc(maze: ^Maze($T)) {
    for &cell in maze.cells {
        maze_cell_destroy(&cell)
    }
    delete(maze.cells)
    delete(maze.doors)
}

maze_reset :: proc(maze:^Maze($T)) {
    for &cell in maze.cells {
        maze_cell_reset(cell)
    }
}

maze_generate :: proc(maze: ^Maze($T)) {
    maze_reset(maze)
    cell: ^Maze_Cell(T) = maze_get_cell(maze, rng_from_int_range(0, maze.columns - 1), rng_from_int_range(0, maze.rows - 1))
    inside: = make(map[^Maze_Cell(T)]struct{}, context.temp_allocator)
    inside[cell]={}
    frontier:= maze_cell_get_neighbors(cell, context.temp_allocator)
    for len(frontier) > 0 {
        ok: bool
        if cell, ok = rng_from_set(&frontier); ok {
            candidates := make([dynamic]T)
            defer delete(candidates)
            for direction, neighbor in cell.neighbors {
                if _, ok = inside[neighbor]; ok {
                    append(&candidates, direction)
                }
            }
            direction:= rng_from_list(&candidates)
            door:= maze_cell_get_door(cell, direction)
            door.open = true
            delete_key(&frontier, cell)
            for direction, neighbor in cell.neighbors {
                if _, ok = inside[neighbor]; !ok {
                    if _, ok = frontier[neighbor]; !ok {
                        frontier[neighbor]={}
                    }
                }
            }
        }
    }
}

maze_get_cell :: proc(maze: ^Maze($T), column, row:int) -> ^MazeCell(T) {
    if column < 0 || row < 0 || column > maze.columns-1 || row > maze.rows -1 {
        return nil
    }
    return maze.cells[column + row * maze.columns]
}