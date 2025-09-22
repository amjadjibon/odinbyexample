package main

import "core:fmt"

main :: proc() {
	// Value Types
	x: int = 42
	fmt.println("x =", x)

	// Pointer Types
	p: ^int = &x
	fmt.println("p =", p)

	// Dereferencing a Pointer
	fmt.println("x =", x, ", p^ =", p^)

	// Modifying Value via Pointer
	p^ = 21
	fmt.println("After modifying:", "x =", x, ", p^ =", p^)
}
