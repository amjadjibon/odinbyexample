package main

import "core:fmt"


main :: proc() {
	fmt.println("Main: about to panic")
	panic("Something went wrong")
	// This line will never be reached
	// fmt.println("Main: all done")
}
