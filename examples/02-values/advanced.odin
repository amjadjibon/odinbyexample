package main

import "core:fmt"

// Alias
MY_INT :: int
#assert(MY_INT == int)

// Distinct
MY_INT2 :: distinct int
#assert(MY_INT2 != int)


main :: proc() {
	i: MY_INT = 10
	fmt.println("MY INT:", i)
	assert(i == 10)

	j: MY_INT2 = 10
	fmt.println("MY INT2:", j)
	assert(j == 10)

	k: int = 10
	assert(i == k)
	// assert(j == k) // j and k are different types
}
