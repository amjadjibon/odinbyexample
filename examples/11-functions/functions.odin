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

/*
Shadowing Parameters
To mutate the procedure parameter (like in C), an explicit copy is required.
This can be done through shadowing the variable declaration:
*/
shadow :: proc(x: int) {
	x := x // explicit mutation
	for x > 0 {
		fmt.println(x)
		x -= 1
	}
}


main :: proc() {
	foo()

	result := anwser()
	fmt.println("The answer is:", result)

	sum := add(3, 5)
	fmt.println("3 + 5 =", sum)

	x, y := swap(10, 20)
	fmt.println("Swapped:", x, y)

	shadow(5)
}
