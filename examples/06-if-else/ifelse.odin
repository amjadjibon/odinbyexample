package main

import "core:fmt"

ternary_example :: proc(x: int) -> string {
	return x > 0 ? "positive" : "negative"
}

main :: proc() {
	x := 10
	if x < 20 {
		fmt.println("x is less than 20")
	} else if x == 20 {
		fmt.println("x is equal to 20")
	} else {
		fmt.println("x is greater than 20")
	}

	if y := 15; y > 10 {
		fmt.println("y is greater than 10")
	} else {
		fmt.println("y is not greater than 10")
	}

	fmt.println("x is: ", ternary_example(x))

	DEBUG_LOG_SIZE :: 1024 when ODIN_DEBUG else 0
	fmt.println("DEBUG_LOG_SIZE is: ", DEBUG_LOG_SIZE)
}
