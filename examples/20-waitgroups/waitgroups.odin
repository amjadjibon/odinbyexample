package main

import "core:fmt"
import "core:sync"
import "core:thread"
import "core:time"

worker :: proc(t: ^thread.Thread) {
	wg := cast(^sync.Wait_Group)t.data
	fmt.printf("Work start from thread %d\n", t.user_index)
	time.sleep(2 * time.Second)
	fmt.printf("Work done from thread %d\n", t.user_index)
	sync.wait_group_done(wg)
}

main :: proc() {
	start := time.now()

	wg: sync.Wait_Group

	// Add 2 threads to the wait group
	sync.wait_group_add(&wg, 2)

	for i in 1 ..= 2 {
		t := thread.create(worker)
		if t != nil {
			t.init_context = context
			t.user_index = i
			t.data = &wg
			thread.start(t)
		}
	}

	// Wait for all worker threads to finish
	sync.wait_group_wait(&wg)
	fmt.println("All workers done in: ", time.diff(start, time.now()))
}
