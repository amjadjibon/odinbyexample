package main

import "core:fmt"
import "core:slice"

main :: proc() {
	// 1D Array
	arr: [5]int = [5]int{1, 2, 3, 4, 5}
	fmt.println("Array: ", arr)
	fmt.println("Length: ", len(arr))
	fmt.println("First Element: ", arr[0])

	// Modifying an array element
	arr[0] = 10
	fmt.println("Updated Array", arr)

	// Iterating over an array
	for i in 0 ..< len(arr) {
		fmt.println("Element ", i, ": ", arr[i])
	}

	// 2D Array
	ddarray: [3][3]int = [3][3]int{[3]int{1, 2, 3}, [3]int{4, 5, 6}, [3]int{7, 8, 9}}
	fmt.println("2D Array: ", ddarray)
	fmt.println("Element at (1,1): ", ddarray[1][1])

	// Iterating over a 2D array
	for i in 0 ..< len(ddarray) {
		for j in 0 ..< len(ddarray[i]) {
			fmt.print(ddarray[i][j], " ")
		}
		fmt.println()
	}

	// Dynamic Arrays
	dynamic_arrays()
}
