package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WINDOW_SIZE :: 800
GRID_WIDTH :: 20
CELL_SIZE :: 16
CANVAS_SIZE :: GRID_WIDTH * CELL_SIZE
TICK_RATE :: 0.13
MAX_SNAKE_LENGTH :: GRID_WIDTH * GRID_WIDTH
Vec2i :: [2]int
food_pos: Vec2i

snake_length: int
tick_timer: f32 = TICK_RATE
move_direction: Vec2i
snake: [MAX_SNAKE_LENGTH]Vec2i
game_over: bool
highest_score: int

place_food :: proc() {
	occupied: [GRID_WIDTH][GRID_WIDTH]bool

	for i in 0 ..< snake_length {
		occupied[snake[i].x][snake[i].y] = true
	}

	free_cells := make([dynamic]Vec2i, context.temp_allocator)
	for x in 0 ..< GRID_WIDTH {
		for y in 0 ..< GRID_WIDTH {
			if !occupied[x][y] {
				append(&free_cells, Vec2i{x, y})
			}
		}
	}

	if len(free_cells) > 0 {
		random_cell_index := rl.GetRandomValue(0, i32(len(free_cells)) - 1)
		food_pos = free_cells[random_cell_index]
	}
}

restart :: proc() {
	snake_length = 3
	tick_timer = TICK_RATE
	move_direction = {0, 1}
	snake[0] = Vec2i{GRID_WIDTH / 2, GRID_WIDTH / 2}
	snake[1] = snake[0] - Vec2i{0, 1}
	snake[2] = snake[0] - Vec2i{0, 2}
	game_over = false
	place_food()
}

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_SIZE, WINDOW_SIZE, "Snake")
	rl.InitAudioDevice()

	restart()

	food_sprite := rl.LoadTexture("assets/food.png")
	head_sprite := rl.LoadTexture("assets/head.png")
	body_sprite := rl.LoadTexture("assets/body.png")
	tail_sprite := rl.LoadTexture("assets/tail.png")

	eat_sound := rl.LoadSound("assets/eat.wav")
	crash_sound := rl.LoadSound("assets/crash.wav")

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

		if game_over {
			if rl.IsKeyPressed(.ENTER) {
				restart()
			}
		} else {
			tick_timer -= rl.GetFrameTime()
		}


		if tick_timer <= 0 {
			next_part_pos := snake[0]
			snake[0] += move_direction
			head_pos := snake[0]

			if head_pos.x < 0 ||
			   head_pos.x >= GRID_WIDTH ||
			   head_pos.y < 0 ||
			   head_pos.y >= GRID_WIDTH {
				game_over = true
				rl.PlaySound(crash_sound)
			}

			for i in 1 ..< snake_length {
				curr_pos := snake[i]
				if curr_pos == head_pos {
					game_over = true
					rl.PlaySound(crash_sound)
				}

				snake[i] = next_part_pos
				next_part_pos = curr_pos
			}


			if head_pos == food_pos {
				snake_length += 1
				snake[snake_length - 1] = next_part_pos
				place_food()
				rl.PlaySound(eat_sound)
			}

			tick_timer = TICK_RATE + tick_timer
		}

		rl.BeginDrawing()
		rl.ClearBackground({76, 53, 83, 255})

		camera := rl.Camera2D {
			zoom = f32(WINDOW_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		rl.DrawTextureV(
			food_sprite,
			{f32(food_pos.x * CELL_SIZE), f32(food_pos.y * CELL_SIZE)},
			rl.RED,
		)

		for i in 0 ..< snake_length {
			pos := snake[i]
			part_sprite := body_sprite
			dir: Vec2i

			if i == 0 {
				part_sprite = head_sprite
				dir = snake[i] - snake[i + 1]
			} else if i == snake_length - 1 {
				part_sprite = tail_sprite
				dir = snake[i - 1] - snake[i]
			} else {
				dir = snake[i - 1] - snake[i]
			}

			rot := math.atan2(f32(dir.y), f32(dir.x)) * math.DEG_PER_RAD
			source := rl.Rectangle{0, 0, f32(part_sprite.width), f32(part_sprite.height)}

			dest := rl.Rectangle {
				f32(pos.x) * CELL_SIZE + 0.5 * CELL_SIZE,
				f32(pos.y) * CELL_SIZE + 0.5 * CELL_SIZE,
				CELL_SIZE,
				CELL_SIZE,
			}

			rl.DrawTexturePro(
				part_sprite,
				source,
				dest,
				{CELL_SIZE, CELL_SIZE} * 0.5,
				rot,
				rl.WHITE,
			)
		}

		if game_over {
			rl.DrawText("Game Over", 4, 4, 25, rl.RED)
			rl.DrawText("Press Enter to Restart", 4, 30, 15, rl.BLACK)
		}

		score := snake_length - 3
		score_text := fmt.ctprintf("Score: %d", score)

		if score > highest_score {
			highest_score = score
		}

		rl.DrawText(score_text, 4, CANVAS_SIZE - 14, 10, rl.GRAY)

		highest_score_text := fmt.ctprintf("Highest Score: %d", highest_score)
		rl.DrawText(highest_score_text, 4, CANVAS_SIZE - 28, 10, rl.GRAY)

		rl.EndMode2D()
		rl.EndDrawing()
		free_all(context.temp_allocator)
	}

	rl.UnloadTexture(food_sprite)
	rl.UnloadTexture(head_sprite)
	rl.UnloadTexture(body_sprite)
	rl.UnloadTexture(tail_sprite)

	rl.CloseAudioDevice()

	rl.CloseWindow()
}
