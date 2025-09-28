package main

import rl "vendor:raylib"

WINDOW_SIZE :: 1000
GRID_WIDTH :: 20
CELL_SIZE :: 16
CANVAS_SIZE :: GRID_WIDTH * CELL_SIZE
Vec2i :: [2]int
snake_head_position: Vec2i

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_SIZE, WINDOW_SIZE, "Snake")

	snake_head_position = Vec2i{GRID_WIDTH / 2, GRID_WIDTH / 2}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground({76, 53, 83, 255})

		camera := rl.Camera2D {
			zoom = f32(WINDOW_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		head_rect := rl.Rectangle {
			x      = f32(snake_head_position.x * CELL_SIZE),
			y      = f32(snake_head_position.y * CELL_SIZE),
			width  = CELL_SIZE,
			height = CELL_SIZE,
		}
		rl.DrawRectangleRec(head_rect, rl.WHITE)

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
