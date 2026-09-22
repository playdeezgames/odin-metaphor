package extension_tests

import "core:testing"
import "../extension"

Direction:: enum {
    North,
    East,
    South,
    West
}

@(test)
test_maze_cell_init :: proc(t: ^testing.T) {
    sut:extension.Maze_Cell(Direction)
    extension.maze_cell_init(&sut)

    testing.expect(t, len(sut.neighbors)==0)
    testing.expect(t, len(sut.doors)==0)
}

@(test)
test_maze_cell_has_neighbor :: proc(t: ^testing.T) {
    sut:extension.Maze_Cell(Direction)
    extension.maze_cell_init(&sut)

    MAZE_DIRECTION :: Direction.North

    actual:= extension.maze_cell_has_neighbor(&sut, MAZE_DIRECTION)

    testing.expect(t, !actual)
}

@(test)
test_maze_cell_get_neighbor :: proc(t: ^testing.T) {
    sut:extension.Maze_Cell(Direction)
    extension.maze_cell_init(&sut)

    MAZE_DIRECTION :: Direction.North

    actual:= extension.maze_cell_get_neighbor(&sut, MAZE_DIRECTION)

    testing.expect(t, actual == nil)
}

@(test)
test_maze_cell_set_neighbor :: proc(t: ^testing.T) {
    sut:extension.Maze_Cell(Direction)
    extension.maze_cell_init(&sut)
    defer extension.maze_cell_destroy(&sut)

    MAZE_DIRECTION :: Direction.North
    extension.maze_cell_set_neighbor(&sut, MAZE_DIRECTION, &sut)

    testing.expect(t, extension.maze_cell_has_neighbor(&sut, MAZE_DIRECTION))

    actual:= extension.maze_cell_get_neighbor(&sut, MAZE_DIRECTION)

    testing.expect(t, actual == &sut)
}