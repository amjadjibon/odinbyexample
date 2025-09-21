package main

import "core:fmt"

main :: proc() {
	answer := 42
	switch answer {
	case 0:
		fmt.println("The answer is zero")
	case 1, 2, 3:
		fmt.println("The answer is one, two, or three")
	case 42:
		fmt.println("The answer to life, the universe, and everything")
	case:
		fmt.println("The answer is something else")
	}
}
