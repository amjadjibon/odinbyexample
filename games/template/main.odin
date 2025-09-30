package main

import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

// Main game function
main :: proc() {
	// Setup memory tracking in debug builds
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	// Initialize Raylib
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_TITLE)
	rl.SetTargetFPS(TARGET_FPS)
	rl.InitAudioDevice()

	// Initialize game
	game := GameState{}
	init_game(&game)

	// Load assets
	assets := load_assets()
	defer unload_assets(&assets)

	// Main game loop with fixed timestep
	for !rl.WindowShouldClose() {
		frame_time := rl.GetFrameTime()
		game.accumulator += frame_time

		// Handle input
		input := handle_input(&game)

		// Fixed timestep updates
		for game.accumulator >= FIXED_TIMESTEP {
			update_game(&game, input, &assets, FIXED_TIMESTEP)
			game.accumulator -= FIXED_TIMESTEP
		}

		// Render
		render_game(&game, &assets)
	}

	// Cleanup
	rl.CloseAudioDevice()
	rl.CloseWindow()
}
