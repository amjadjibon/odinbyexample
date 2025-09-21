package main

import "core:fmt"

// Function with no parameters and no return value
foo :: proc() {
	fmt.println("Hello from foo!")
}

// Function that returns an integer
anwser :: proc() -> int {
	return 42
}

// Function with parameters and return value
add :: proc(a: int, b: int) -> int {
	return a + b
}

// Function with multiple return values
swap :: proc(a: int, b: int) -> (int, int) {
	return b, a
}

main :: proc() {
	foo()

	result := anwser()
	fmt.println("The answer is:", result)

	sum := add(3, 5)
	fmt.println("3 + 5 =", sum)

	x, y := swap(10, 20)
	fmt.println("Swapped:", x, y)
}
