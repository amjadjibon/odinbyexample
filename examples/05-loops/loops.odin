package main

import "core:fmt"

main :: proc() {
	n := 5

	// For loop with initialization, condition, and increment
	for i := 0; i < n; i += 1 {
		fmt.println("Iteration", i)
	}

	// While-like loop
	j := 0
	for j < n {
		fmt.println("While-like loop iteration", j)
		j += 1
	}

	// Infinite loop with break
	k := 0
	for {
		if k >= n {
			break
		}
		fmt.println("Infinite loop iteration", k)
		k += 1
	}
}
