package main

import "core:fmt"
import "core:os"

main :: proc() {
	// Get a specific environment variable
	home := os.get_env("HOME") // Unix-like
	fmt.println("Home directory:", home)

	// Get another variable
	path := os.get_env("PATH")
	fmt.println("PATH:", path)

	// Check if a variable exists
	if my_var := os.get_env("MY_VAR"); my_var == "" {
		fmt.println("MY_VAR is not set")
	}

	// Set a new environment variable
	os.set_env("MY_VAR", "new_value")
	fmt.println("MY_VAR =", os.get_env("MY_VAR"))

	os.unset_env("MY_VAR")

	my_var := os.get_env("MY_VAR")
	if my_var == "" {
		fmt.println("MY_VAR is not set")
	}
}
