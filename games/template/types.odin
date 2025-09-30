package main

import rl "vendor:raylib"

// Game configuration constants - modify these for your game
WINDOW_WIDTH :: 800
WINDOW_HEIGHT :: 600
WINDOW_TITLE :: "Odin Game Template"
TARGET_FPS :: 60

// Game timing
FIXED_TIMESTEP :: 1.0 / 60.0 // 60 FPS fixed timestep

// Structure to hold all game assets (textures, sounds, etc.)
GameAssets :: struct {
	// Add your game assets here
	// Example:
	// player_texture: rl.Texture2D,
	// background_music: rl.Music,
	// jump_sound: rl.Sound,
}

// Structure to hold all game state variables
GameState :: struct {
	// Game timing
	accumulator: f32,

	// Game state flags
	is_paused:   bool,
	game_over:   bool,

	// Add your game-specific state here
	// Example:
	// player_pos: rl.Vector2,
	// score: int,
	// level: int,
}

// Input handling - map keys to actions
InputState :: struct {
	up:      bool,
	down:    bool,
	left:    bool,
	right:   bool,
	action:  bool,
	pause:   bool,
	restart: bool,
}
