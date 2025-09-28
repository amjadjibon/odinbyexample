package main

import rl "vendor:raylib"

WINDOW_SIZE :: 1000
GRID_WIDTH :: 20
CELL_SIZE :: 16
CANVAS_SIZE :: GRID_WIDTH * CELL_SIZE
TICK_RATE :: 0.13
MAX_SNAKE_LENGTH :: GRID_WIDTH * GRID_WIDTH
Vec2i :: [2]int

snake_length: int
tick_timer: f32 = TICK_RATE
move_direction: Vec2i
snake: [MAX_SNAKE_LENGTH]Vec2i

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_SIZE, WINDOW_SIZE, "Snake")

	start_head_position := Vec2i{GRID_WIDTH / 2, GRID_WIDTH / 2}
	snake[0] = start_head_position
	snake[1] = start_head_position - Vec2i{0, 1}
	snake[2] = start_head_position - Vec2i{0, 2}
	snake_length = 3
	move_direction = {0, 1}

	for !rl.WindowShouldClose() {
		if rl.IsKeyDown(.UP) {
			move_direction = {0, -1}
		} else if rl.IsKeyDown(.DOWN) {
			move_direction = {0, 1}
		} else if rl.IsKeyDown(.LEFT) {
			move_direction = {-1, 0}
		} else if rl.IsKeyDown(.RIGHT) {
			move_direction = {1, 0}
		}

		tick_timer -= rl.GetFrameTime()

		if tick_timer <= 0 {
			next_part_pos := snake[0]
			snake[0] += move_direction
			for i in 1 ..< snake_length {
				snake[i], next_part_pos = next_part_pos, snake[i]
			}
			tick_timer = TICK_RATE + tick_timer
		}

		rl.BeginDrawing()
		rl.ClearBackground({76, 53, 83, 255})

		camera := rl.Camera2D {
			zoom = f32(WINDOW_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		for i in 0 ..< snake_length {
			head_rect := rl.Rectangle {
				x      = f32(snake[i].x * CELL_SIZE),
				y      = f32(snake[i].y * CELL_SIZE),
				width  = CELL_SIZE,
				height = CELL_SIZE,
			}
			rl.DrawRectangleRec(head_rect, rl.WHITE)
		}


		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
