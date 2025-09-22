package main

import "core:fmt"

foo :: proc() {
	fmt.println("foo: this is foo")
}

bar :: proc() {
	fmt.println("bar: this is bar")
}

answer :: proc() -> int {
	defer fmt.println("answer: about to return 42")
	return 42
}

main :: proc() {
	defer foo()
	defer bar()

	result := answer()
	fmt.printf("Main: the answer is %d\n", result)

	fmt.println("Main: all done")
}

// Output:
// answer: about to return 42
// Main: the answer is 42
// Main: all done
// bar: this is bar
// foo: this is foo
//
// Multiple deferred calls are executed in last-in-first-out order when the surrounding function returns
