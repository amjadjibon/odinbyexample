package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

// Game configuration constants
WINDOW_SIZE :: 800 // Window size in pixels
GRID_WIDTH :: 20 // Grid size (20x20 cells)
CELL_SIZE :: 16 // Size of each grid cell in pixels
CANVAS_SIZE :: GRID_WIDTH * CELL_SIZE // Total canvas size
TICK_RATE :: 0.13 // Game update rate in seconds
MAX_SNAKE_LENGTH :: GRID_WIDTH * GRID_WIDTH // Maximum possible snake length

// 2D integer vector type for positions
Vec2i :: [2]int

// Structure to hold all game assets (textures and sounds)
GameAssets :: struct {
	food_sprite: rl.Texture2D, // Food texture
	head_sprite: rl.Texture2D, // Snake head texture
	body_sprite: rl.Texture2D, // Snake body texture
	tail_sprite: rl.Texture2D, // Snake tail texture
	eat_sound:   rl.Sound, // Sound when eating food
	crash_sound: rl.Sound, // Sound when game over
}

// Structure to hold all game state variables
GameState :: struct {
	food_pos:       Vec2i, // Current food position
	snake_length:   int, // Current snake length
	tick_timer:     f32, // Timer for game updates
	move_direction: Vec2i, // Current movement direction
	snake:          [MAX_SNAKE_LENGTH]Vec2i, // Snake body positions
	game_over:      bool, // Game over state
	highest_score:  int, // Highest score achieved
}

// Places food at a random unoccupied position on the grid
place_food :: proc(game: ^GameState) {
	occupied: [GRID_WIDTH][GRID_WIDTH]bool

	// Mark all snake positions as occupied
	for i in 0 ..< game.snake_length {
		occupied[game.snake[i].x][game.snake[i].y] = true
	}

	// Find all free cells
	free_cells := make([dynamic]Vec2i, context.temp_allocator)
	for x in 0 ..< GRID_WIDTH {
		for y in 0 ..< GRID_WIDTH {
			if !occupied[x][y] {
				append(&free_cells, Vec2i{x, y})
			}
		}
	}

	// Place food at random free cell
	if len(free_cells) > 0 {
		random_cell_index := rl.GetRandomValue(0, i32(len(free_cells)) - 1)
		game.food_pos = free_cells[random_cell_index]
	}
}

// Resets the game to initial state
restart_game :: proc(game: ^GameState) {
	game.snake_length = 3 // Start with 3 segments
	game.tick_timer = TICK_RATE // Reset timer
	game.move_direction = {0, 1} // Start moving down
	game.snake[0] = Vec2i{GRID_WIDTH / 2, GRID_WIDTH / 2} // Head in center
	game.snake[1] = game.snake[0] - Vec2i{0, 1} // Body segment above head
	game.snake[2] = game.snake[0] - Vec2i{0, 2} // Tail segment above body
	game.game_over = false // Reset game over state
	place_food(game) // Place initial food
}

// Handles keyboard input for movement and game restart
handle_input :: proc(game: ^GameState) {
	// Handle movement input (arrow keys) - prevent reversing into self
	if rl.IsKeyDown(.UP) && game.move_direction != {0, 1} {
		game.move_direction = {0, -1} // Move up (if not moving down)
	} else if rl.IsKeyDown(.DOWN) && game.move_direction != {0, -1} {
		game.move_direction = {0, 1} // Move down (if not moving up)
	} else if rl.IsKeyDown(.LEFT) && game.move_direction != {1, 0} {
		game.move_direction = {-1, 0} // Move left (if not moving right)
	} else if rl.IsKeyDown(.RIGHT) && game.move_direction != {-1, 0} {
		game.move_direction = {1, 0} // Move right (if not moving left)
	}

	// Handle restart when game is over
	if game.game_over && rl.IsKeyPressed(.ENTER) {
		restart_game(game)
	}
}

// Updates game logic and handles collisions
update_game :: proc(game: ^GameState, assets: ^GameAssets) {
	// Don't update if game is over
	if game.game_over {
		return
	}

	// Update timer
	game.tick_timer -= rl.GetFrameTime()

	// Only update game state when tick timer expires
	if game.tick_timer <= 0 {
		// Move snake: save current head position and move head forward
		next_part_pos := game.snake[0]
		game.snake[0] += game.move_direction
		head_pos := game.snake[0]

		// Check wall collision
		if head_pos.x < 0 ||
		   head_pos.x >= GRID_WIDTH ||
		   head_pos.y < 0 ||
		   head_pos.y >= GRID_WIDTH {
			game.game_over = true
			rl.PlaySound(assets.crash_sound)
		}

		// Move body segments and check self collision
		for i in 1 ..< game.snake_length {
			curr_pos := game.snake[i]
			// Check if head collides with body
			if curr_pos == head_pos {
				game.game_over = true
				rl.PlaySound(assets.crash_sound)
			}

			// Move each segment to where the previous one was
			game.snake[i] = next_part_pos
			next_part_pos = curr_pos
		}

		// Check food collision
		if head_pos == game.food_pos {
			game.snake_length += 1 // Grow snake
			game.snake[game.snake_length - 1] = next_part_pos // Add new tail segment
			place_food(game) // Place new food
			rl.PlaySound(assets.eat_sound) // Play eat sound
		}

		// Reset timer for next tick
		game.tick_timer = TICK_RATE + game.tick_timer
	}
}

// Renders the entire game scene
render_game :: proc(game: ^GameState, assets: ^GameAssets) {
	rl.BeginDrawing()
	rl.ClearBackground({76, 53, 83, 255}) // Dark purple background

	// Set up camera for pixel-perfect scaling
	camera := rl.Camera2D {
		zoom = f32(WINDOW_SIZE) / CANVAS_SIZE,
	}
	rl.BeginMode2D(camera)

	// Draw food
	rl.DrawTextureV(
		assets.food_sprite,
		{f32(game.food_pos.x * CELL_SIZE), f32(game.food_pos.y * CELL_SIZE)},
		rl.RED,
	)

	// Draw snake segments
	for i in 0 ..< game.snake_length {
		pos := game.snake[i]
		part_sprite := assets.body_sprite // Default to body sprite
		dir: Vec2i

		// Determine sprite and direction based on segment position
		if i == 0 {
			// Head: direction from head to next segment
			part_sprite = assets.head_sprite
			dir = game.snake[i] - game.snake[i + 1]
		} else if i == game.snake_length - 1 {
			// Tail: direction from previous segment to tail
			part_sprite = assets.tail_sprite
			dir = game.snake[i - 1] - game.snake[i]
		} else {
			// Body: direction from previous segment to current
			dir = game.snake[i - 1] - game.snake[i]
		}

		// Calculate rotation based on direction
		rot := math.atan2(f32(dir.y), f32(dir.x)) * math.DEG_PER_RAD
		source := rl.Rectangle{0, 0, f32(part_sprite.width), f32(part_sprite.height)}

		// Set destination rectangle (centered on grid cell)
		dest := rl.Rectangle {
			f32(pos.x) * CELL_SIZE + 0.5 * CELL_SIZE,
			f32(pos.y) * CELL_SIZE + 0.5 * CELL_SIZE,
			CELL_SIZE,
			CELL_SIZE,
		}

		// Draw rotated sprite
		rl.DrawTexturePro(part_sprite, source, dest, {CELL_SIZE, CELL_SIZE} * 0.5, rot, rl.WHITE)
	}

	// Draw game over screen
	if game.game_over {
		rl.DrawText("Game Over", 4, 4, 25, rl.RED)
		rl.DrawText("Press Enter to Restart", 4, 30, 15, rl.BLACK)
	}

	// Calculate and display score
	score := game.snake_length - 3
	score_text := fmt.ctprintf("Score: %d", score)

	// Update highest score if current score is higher
	if score > game.highest_score {
		game.highest_score = score
	}

	// Draw score information
	rl.DrawText(score_text, 4, CANVAS_SIZE - 14, 10, rl.GRAY)

	highest_score_text := fmt.ctprintf("Highest Score: %d", game.highest_score)
	rl.DrawText(highest_score_text, 4, CANVAS_SIZE - 28, 10, rl.GRAY)

	rl.EndMode2D()
	rl.EndDrawing()
	free_all(context.temp_allocator) // Clean up temporary allocations
}

// Loads all game assets from disk
load_assets :: proc() -> GameAssets {
	return GameAssets {
		food_sprite = rl.LoadTexture("assets/food.png"), // Food texture
		head_sprite = rl.LoadTexture("assets/head.png"), // Snake head texture
		body_sprite = rl.LoadTexture("assets/body.png"), // Snake body texture
		tail_sprite = rl.LoadTexture("assets/tail.png"), // Snake tail texture
		eat_sound   = rl.LoadSound("assets/eat.wav"), // Eating sound effect
		crash_sound = rl.LoadSound("assets/crash.wav"), // Crash sound effect
	}
}

// Unloads all game assets to free memory
unload_assets :: proc(assets: ^GameAssets) {
	rl.UnloadTexture(assets.food_sprite)
	rl.UnloadTexture(assets.head_sprite)
	rl.UnloadTexture(assets.body_sprite)
	rl.UnloadTexture(assets.tail_sprite)
}

// Main function - entry point of the program
main :: proc() {
	// Initialize Raylib
	rl.SetConfigFlags({.VSYNC_HINT}) // Enable vsync
	rl.InitWindow(WINDOW_SIZE, WINDOW_SIZE, "Snake") // Create window
	rl.InitAudioDevice() // Initialize audio

	// Initialize game state
	game := GameState{}
	restart_game(&game)

	// Load assets with automatic cleanup on exit
	assets := load_assets()
	defer unload_assets(&assets)

	// Main game loop
	for !rl.WindowShouldClose() {
		handle_input(&game) // Process player input
		update_game(&game, &assets) // Update game logic
		render_game(&game, &assets) // Render graphics
	}

	// Cleanup
	rl.CloseAudioDevice()
	rl.CloseWindow()
}
