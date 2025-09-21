package main

import "core:fmt"
import "core:slice"

main :: proc() {
	// Creating a slice
	s := []int{1, 2, 3, 4, 5}
	fmt.println("Original slice:", s)
	fmt.println("Length:", len(s))

	// Copy a slice
	dest := make([]int, len(s))
	copy(dest, s)
	fmt.println("Copied slice:", dest)

	// Slicing a slice
	subSlice := s[:] // Slicing from start to end
	fmt.println("Sub-slice (full):", subSlice)
	subSlice2 := s[1:4] // Slicing from index 1 to index 4 (exclusive)
	fmt.println("Sub-slice (1 to 4):", subSlice2)
	subSlice3 := s[:3] // Slicing from start to index 3 (exclusive)
	fmt.println("Sub-slice (start to 3):", subSlice3)
	subSlice4 := s[2:] // Slicing from index 2 to end
	fmt.println("Sub-slice (2 to end):", subSlice4)
}
