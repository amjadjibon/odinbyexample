package main

import rl "vendor:raylib"

// Load all game assets
load_assets :: proc() -> GameAssets {
	assets := GameAssets{}

	// Load your assets here
	// Example:
	// assets.player_texture = rl.LoadTexture("assets/player.png")
	// assets.background_music = rl.LoadMusicStream("assets/bgm.ogg")
	// assets.jump_sound = rl.LoadSound("assets/jump.wav")

	return assets
}

// Unload all game assets
unload_assets :: proc(assets: ^GameAssets) {
	// Unload your assets here
	// Example:
	// rl.UnloadTexture(assets.player_texture)
	// rl.UnloadMusicStream(assets.background_music)
	// rl.UnloadSound(assets.jump_sound)
}
