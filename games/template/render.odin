package main

import rl "vendor:raylib"

// Render the game scene
render_game :: proc(game: ^GameState, assets: ^GameAssets) {
	rl.BeginDrawing()
	rl.ClearBackground(rl.DARKBLUE)

	// Render your game here
	if !game.game_over {
		// Game rendering
		// Example:
		// rl.DrawCircleV(game.player_pos, 20, rl.WHITE)

		// Debug info
		rl.DrawText("Use WASD or Arrow Keys to move", 10, 10, 20, rl.WHITE)
		rl.DrawText("Press SPACE/ENTER for action", 10, 35, 20, rl.WHITE)
		rl.DrawText("Press P/ESC to pause", 10, 60, 20, rl.WHITE)

		if game.is_paused {
			// Pause overlay
			rl.DrawRectangle(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, {0, 0, 0, 128})
			rl.DrawText(
				"PAUSED",
				WINDOW_WIDTH / 2 - rl.MeasureText("PAUSED", 40) / 2,
				WINDOW_HEIGHT / 2 - 20,
				40,
				rl.WHITE,
			)
		}
	} else {
		// Game over screen
		rl.DrawText(
			"GAME OVER",
			WINDOW_WIDTH / 2 - rl.MeasureText("GAME OVER", 40) / 2,
			WINDOW_HEIGHT / 2 - 40,
			40,
			rl.RED,
		)
		rl.DrawText(
			"Press R to restart",
			WINDOW_WIDTH / 2 - rl.MeasureText("Press R to restart", 20) / 2,
			WINDOW_HEIGHT / 2 + 10,
			20,
			rl.WHITE,
		)
	}

	rl.EndDrawing()
}
