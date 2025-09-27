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

// Default input
default_input :: proc(input: int = 42) -> string {
	if input == 42 {
		return "default"
	}
	return "input changed"
}

// Named result
do_math :: proc(input: int) -> (x, y: int) {
	x = 2 * input + 1
	y = 3 * input / 5
	return x, y
}

do_math_with_naked_return :: proc(input: int) -> (x, y: int) {
	x = 2 * input + 1
	y = 3 * input / 5
	return // A "naked" return statement, as no values are explicitly specified.
}

conditionally_blue :: proc(red: bool) -> (color := "blue") {
	if red {
		return "red"
	}
	return
}

sum_ints :: proc(nums: ..int) -> (result: int) {
	for n in nums {
		result += n
	}
	return result
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
	fmt.println(default_input(42))
	fmt.println(default_input(43))

	fmt.println("Sum []:", sum_ints()) // 0
	fmt.println("Sum [1, 2]:", sum_ints(1, 2)) // 3
	fmt.println("Sum [1, 2, 3, 4, 5]:", sum_ints(1, 2, 3, 4, 5)) // 15

	odds := []int{1, 3, 5}
	fmt.println("Sum odds:", sum_ints(..odds)) // 9, passing a slice as varargs
}
