package main

import rl "vendor:raylib"

// Handle all input processing
handle_input :: proc(game: ^GameState) -> InputState {
	input := InputState{}

	// Map keyboard input to game actions
	input.up = rl.IsKeyDown(.UP) || rl.IsKeyDown(.W)
	input.down = rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S)
	input.left = rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A)
	input.right = rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D)
	input.action = rl.IsKeyPressed(.SPACE) || rl.IsKeyPressed(.ENTER)
	input.pause = rl.IsKeyPressed(.P) || rl.IsKeyPressed(.ESCAPE)
	input.restart = rl.IsKeyPressed(.R)

	// Handle global game state input
	if input.pause {
		game.is_paused = !game.is_paused
	}

	if input.restart && game.game_over {
		restart_game(game)
	}

	return input
}
