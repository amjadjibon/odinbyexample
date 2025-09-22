package main

import "core:fmt"
import "core:thread"

worker :: proc(t: ^thread.Thread) {
	fmt.printf("Hello from thread %d!\n", t.user_index)
}

main :: proc() {
	// Create a thread that runs `worker`
	t := thread.create(worker)
	if t != nil {
		t.init_context = context
		t.user_index = 1

		// Start the thread
		thread.start(t)

		// Wait for it to finish
		thread.join(t)

		fmt.println("Thread finished")
		thread.destroy(t)
	}
}
