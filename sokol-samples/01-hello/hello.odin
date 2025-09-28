package main

import sokol_app "../../shared/sokol/app"
import "core:fmt"

main :: proc() {
	sokol_app.run({width = 600, height = 400, window_title = "Hello World"})
}
