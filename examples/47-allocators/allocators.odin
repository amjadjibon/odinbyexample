package main

import "core:fmt"
import "core:strings"

main :: proc() {
	// `new` - allocates a value of the type given. The result value is a pointer to the type given.
	ptr := new(int) // ptr := new(int, context.allocator)
	ptr^ = 123
	x: int = ptr^
	assert(x == 123)

	// new_clone - allocates a clone of the value passed to it.
	// The resulting value of the type will be a pointer to the type of the value passed.
	ptr2 := new_clone(x)
	assert(ptr2^ == 123)

	// make - allocates memory for a backing data structure of either a slice, dynamic array, or map.
	slice := make([]int, 65)

	dynamic_array_zero_length := make([dynamic]int)
	dynamic_array_with_length := make([dynamic]int, 32)
	dynamic_array_with_length_and_capacity := make([dynamic]int, 16, 64)

	made_map := make(map[string]int)
	made_map_with_reservation := make(map[string]int, 64)

	// free - frees the memory at the pointer given. Note: only free memory with the allocator it was allocated with.
	free(ptr)
	free(ptr2)

	// delete - deletes the backing memory of a value allocated with make or a string that was allocated through an allocator.
	my_dynamic_array := make([dynamic]int)
	delete(my_dynamic_array)

	// free_all - frees all the memory of the context’s allocator (or given allocator).
	// Note: not all allocators support this procedure.
	free_all()
	free_all(context.temp_allocator)
	// free_all(my_allocator) // custom allocator
}
