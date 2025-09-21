package main

import "core:fmt"

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
}
