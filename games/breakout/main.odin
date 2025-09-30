package main

import "core:fmt"
import rl "vendor:raylib"

WINDOW_SIZE :: 800

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT}) // Enable vsync
	rl.InitWindow(WINDOW_SIZE, WINDOW_SIZE, "Breakout") // Create window
	rl.InitAudioDevice() // Initialize audio

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground({76, 53, 83, 255}) // Dark purple background
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
