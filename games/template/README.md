# Odin Game Template

A template for creating games in Odin using Raylib. This template provides a solid foundation with common game development patterns and best practices.

## Features

- **Fixed timestep game loop** - Ensures consistent physics and game logic
- **Separated input handling** - Clean input mapping system
- **Asset management** - Structured loading and unloading of game resources
- **Game state management** - Organized state handling with pause/restart functionality
- **Modular design** - Easy to extend and modify for different game types

## Structure

```
template/
├── main.odin          # Main entry point and game loop
├── types.odin         # Game types and constants
├── game.odin          # Core game logic and state management
├── input.odin         # Input handling
├── render.odin        # Rendering and graphics
├── assets.odin        # Asset loading and management
└── README.md          # This documentation
```

## Quick Start

1. Copy the template directory to start your new game:
   ```bash
   cp -r games/template games/your-game-name
   ```

2. Modify the constants in `types.odin`:
   ```odin
   WINDOW_WIDTH :: 1024     // Your desired window width
   WINDOW_HEIGHT :: 768     // Your desired window height
   WINDOW_TITLE :: "My Game" // Your game title
   ```

3. Add your game-specific data to the structs in `types.odin`:
   ```odin
   GameAssets :: struct {
       player_texture: rl.Texture2D,
       background_music: rl.Music,
       // Add more assets...
   }
   
   GameState :: struct {
       // Keep the template fields
       accumulator: f32,
       is_paused: bool,
       game_over: bool,
       
       // Add your game state
       player_pos: rl.Vector2,
       score: int,
       // Add more state...
   }
   ```

4. Implement your game logic in the appropriate files:
   - `game.odin` - `init_game()`, `update_game()` for core game logic
   - `input.odin` - `handle_input()` for custom input handling
   - `render.odin` - `render_game()` for rendering code
   - `assets.odin` - `load_assets()` / `unload_assets()` for asset management

## Game Loop Architecture

The template uses a **fixed timestep game loop** with the following structure:

```
Input → Fixed Update (60fps) → Render (Variable fps)
```

### Why Fixed Timestep?

- **Consistent behavior** across different framerates
- **Deterministic physics** and game logic
- **Easier debugging** and testing
- **Network-friendly** for multiplayer games

## Key Functions

### Core Functions by File

#### `game.odin`
- **`init_game(game: ^GameState)`** - Initialize your game state to default values. Called once at startup and when restarting.
- **`update_game(game: ^GameState, input: InputState, assets: ^GameAssets, dt: f32)`** - Your main game logic goes here. This runs at a fixed 60 FPS regardless of rendering framerate.

#### `input.odin`
- **`handle_input(game: ^GameState) -> InputState`** - Process keyboard input and return an InputState struct. The template provides common mappings:
  - WASD/Arrow Keys for movement
  - Space/Enter for action
  - P/Escape for pause
  - R for restart (when game over)

#### `render.odin`
- **`render_game(game: ^GameState, assets: ^GameAssets)`** - All rendering code goes here. This runs as fast as possible (capped by VSync).

#### `assets.odin`
- **`load_assets() -> GameAssets`** / **`unload_assets(assets: ^GameAssets)`** - Load and unload your game resources (textures, sounds, music, etc.).

## Default Controls

- **WASD** or **Arrow Keys** - Movement
- **Space** or **Enter** - Action
- **P** or **Escape** - Pause/Unpause
- **R** - Restart (when game over)

## Example: Adding a Player

```odin
// 1. Add to GameState
GameState :: struct {
    // ... template fields ...
    player_pos: rl.Vector2,
    player_speed: f32,
}

// 2. Initialize in init_game
init_game :: proc(game: ^GameState) {
    // ... template initialization ...
    game.player_pos = {WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2}
    game.player_speed = 300 // pixels per second
}

// 3. Update in update_game
update_game :: proc(game: ^GameState, input: InputState, assets: ^GameAssets, dt: f32) {
    if game.is_paused || game.game_over do return
    
    // Move player
    if input.left  do game.player_pos.x -= game.player_speed * dt
    if input.right do game.player_pos.x += game.player_speed * dt
    if input.up    do game.player_pos.y -= game.player_speed * dt
    if input.down  do game.player_pos.y += game.player_speed * dt
}

// 4. Render in render_game
render_game :: proc(game: ^GameState, assets: ^GameAssets) {
    rl.BeginDrawing()
    rl.ClearBackground(rl.DARKBLUE)
    
    if !game.game_over {
        // Draw player
        rl.DrawCircleV(game.player_pos, 20, rl.WHITE)
    }
    
    rl.EndDrawing()
}
```

## Building and Running

Make sure you have Raylib properly set up in your Odin installation, then:

```bash
cd games/your-game-name
odin run .
```

### Debug Build with Memory Tracking

To run with memory leak detection in debug mode:

```bash
odin run . -debug
```

This will automatically track memory allocations and report any leaks when the program exits. The tracking allocator is only enabled in debug builds and has no performance impact in release builds.

## Tips

- **Start simple** - Get basic movement working before adding complex features
- **Use the fixed timestep** - Put game logic in `update_game()`, not `render_game()`
- **Separate concerns** - Keep input, update, and render functions focused
- **Profile early** - Use Raylib's built-in FPS counter: `rl.DrawFPS(10, 10)`
- **Handle edge cases** - Check bounds, handle empty states, etc.

## Common Patterns

### Game States (Menu, Playing, Game Over)
```odin
GameMode :: enum {
    MENU,
    PLAYING,
    GAME_OVER,
}

GameState :: struct {
    mode: GameMode,
    // ... other fields
}
```

### Entity System
```odin
Entity :: struct {
    pos: rl.Vector2,
    vel: rl.Vector2,
    active: bool,
}

GameState :: struct {
    entities: [dynamic]Entity,
    // ... other fields
}
```

### Scene Management
```odin
update_game :: proc(game: ^GameState, input: InputState, assets: ^GameAssets, dt: f32) {
    switch game.mode {
    case .MENU:    update_menu(game, input, dt)
    case .PLAYING: update_gameplay(game, input, dt)
    case .GAME_OVER: update_game_over(game, input, dt)
    }
}
```

Happy game development! 🎮