#+private
package attribute

import "core:fmt"

@(private)
my_variable: int // cannot be accessed outside this package

@(private = "file")
my_other_variable: int // cannot be accessed outside this file

test :: proc() -> int {
	@(static) foo := 0 // This attribute can be applied to a variable to have it keep its state even when going out of scope.
	foo += 1
	return foo
}

@(rodata)
numbers := []int{7, 42, 628}

main :: proc() {
	fmt.println(test()) // prints 1
	fmt.println(test()) // prints 2
	fmt.println(test()) // prints 3

	index := 1
	n := numbers[index]
	// numbers[index] = 12 // Error: Assignment to variable 'numbers' marked as @(rodata) is not allowed
	fmt.println(n)
}
