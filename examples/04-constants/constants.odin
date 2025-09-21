package main

import "core:fmt"

PI :: 3.14

main :: proc() {
	fmt.println("The value of PI is", PI)

	E :: 2.71
	fmt.println("The value of E is", E)

	// E = 2.72 // This will cause a compilation error because E is a constant
}
