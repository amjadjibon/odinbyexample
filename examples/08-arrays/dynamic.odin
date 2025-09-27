package main

import "core:fmt"
import "core:slice"

dynamic_arrays :: proc() {
	arr := [dynamic]int{}
	append(&arr, 1)
	append(&arr, 2)
	append(&arr, 3)
	append(&arr, 4, 5, 6)

	fmt.println(arr)

	x := make([dynamic]int, 0, 16)
	inject_at(&x, 0, 10)
	inject_at(&x, 3, 10) // resizes till length
	fmt.eprintln(x[:], len(x), cap(x)) // [10, 0, 0, 10] 4 16
	assign_at(&x, 3, 20)
	assign_at(&x, 4, 30)
	fmt.eprintln(x[:], len(x), cap(x)) // [10, 0, 0, 20, 30] 5, 16
	assign_at(&x, 5, 40, 50, 60)
	fmt.eprintln(x[:], len(x), cap(x)) // [10, 0, 0, 20, 30, 40, 50, 60] 8 16

	s: [dynamic]int
	append(&s, 1, 6, 3, 5, 7, 3, 0) // [1, 6, 3, 5, 7, 3, 0]
	slice.sort(s[:]) // [0, 1, 3, 3, 5, 6, 7]

	// making and deleting dynamic arrays
	a := make([]int, 6) // len(a) == 6
	b := make([dynamic]int, 6) // len(b) == 6, cap(b) == 6
	c := make([dynamic]int, 0, 6) // len(c) == 0, cap(c) == 6
	d := []int{1, 2, 3} // a slice literal, for comparison

	// with an explicit allocator:
	e := make([]int, 6, context.allocator)
	f := make([dynamic]int, 0, 6, context.allocator)

	delete(a)
	delete(b)
	delete(c)
	// delete(d)                  // no need to clean up slice literals
	delete(e) // slices are always deleted from context.allocator
	delete(f) // dynamic arrays remember their allocator

	// Clearing a dynamic array
	y := [dynamic]int{}
	append(&y, 1, 2, 3, 4, 5) // [1, 2, 3, 4, 5]
	fmt.println(len(x)) // 5
	clear(&x) // []
	fmt.println(len(x)) // 0

	// Resize
	z := [dynamic]int{}
	fmt.println(len(z), cap(z)) // 0 0
	append(&z, 1, 2, 3) // [1, 2, 3]
	fmt.println(len(z), cap(z)) // 3 8
	resize(&z, 5)
	fmt.println(z[:]) // [1, 2, 3, 0, 0] other values are zero'd memory
	fmt.println(len(z), cap(z)) // 5 8
	reserve(&z, 32)
	fmt.println(len(z), cap(z)) // 5 32
	shrink(&z)
	fmt.println(len(z), cap(z)) // 5 5
}
