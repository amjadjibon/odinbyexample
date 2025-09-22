package main

import "core:fmt"
import "core:thread"
import "core:time"

worker :: proc(task: thread.Task) {
	time.sleep(1 * time.Second) // Simulate work
	fmt.printf("Task %d running on thread pool\n", task.user_index)
}

main :: proc() {
	start := time.now()

	pool: thread.Pool
	thread.pool_init(&pool, context.allocator, 4) // 4 worker threads
	thread.pool_start(&pool)
	defer thread.pool_destroy(&pool)

	for i in 1 ..= 6 {
		thread.pool_add_task(&pool, context.allocator, worker, &{}, i)
	}

	thread.pool_finish(&pool)
	fmt.println("All tasks finished: ", time.diff(start, time.now()))
	// Output:
	// Task 1 running on thread pool
	// Task 2 running on thread pool
	// Task 3 running on thread pool
	// Task 4 running on thread pool
	// Task 5 running on thread pool
	// Task 6 running on thread pool
	// All tasks finished: 2s
	// End Output
	// Explanation: With 4 worker threads and 6 tasks,
	// the first 4 tasks run concurrently, taking 1 second.
	// Once a thread is free, it picks up the remaining 2 tasks,
	// resulting in a total time of approximately 2 seconds.
}
