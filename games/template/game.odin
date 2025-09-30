package main

// Initialize game state to default values
init_game :: proc(game: ^GameState) {
	game.accumulator = 0.0
	game.is_paused = false
	game.game_over = false

	// Initialize your game-specific state here
	// Example:
	// game.player_pos = {WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2}
	// game.score = 0
	// game.level = 1
}

// Reset game to initial state
restart_game :: proc(game: ^GameState) {
	init_game(game)
}

// Fixed timestep game update - put your game logic here
update_game :: proc(game: ^GameState, input: InputState, assets: ^GameAssets, dt: f32) {
	// Don't update if paused or game over
	if game.is_paused || game.game_over {
		return
	}

	// Add your game update logic here
	// Example:
	// if input.left {
	//     game.player_pos.x -= 200 * dt
	// }
	// if input.right {
	//     game.player_pos.x += 200 * dt
	// }

	// Example collision detection
	// if check_collision(game.player_pos, enemy_pos) {
	//     game.game_over = true
	// }
}
