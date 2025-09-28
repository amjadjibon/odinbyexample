package main

import "core:fmt"
import "core:mem"

/*
odin run examples/47-allocators/tracking.odin -file -debug
*/

good_stuff :: proc() {
	// Allocate some memory but DO NOT free it — this is the leak!
	ptr := new(int)
	defer free(ptr)
	ptr^ = 42

	// Allocate an array and also don't free it
	arr := new([100]int)
	defer free(arr)
	arr[0] = 123

	fmt.println("Did some good stuff (no leaked memory)!")
}

bad_stuff :: proc() {
	// Allocate some memory but DO NOT free it — this is the leak!
	ptr := new(int)
	ptr^ = 42

	// Allocate an array and also don't free it
	arr := new([100]int)
	arr[0] = 123

	fmt.println("Did some stuff (and leaked memory)!")
}

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	good_stuff()
	bad_stuff()
}
