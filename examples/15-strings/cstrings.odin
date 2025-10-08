package main

import "core:fmt"

cstring_example :: proc() {
	fmt.println("\n# cstring_example")

	W :: "Hellope"
	X :: cstring(W)
	Y :: string(X)

	w := W
	_ = w
	x: cstring = X
	y: string = Y
	z := string(x)
	fmt.println(x, y, z)
	fmt.println(len(x), len(y), len(z))
	fmt.println(len(W), len(X), len(Y))
	// IMPORTANT NOTE for cstring variables
	// len(cstring) is O(N)
	// cast(string)cstring is O(N)
}

main :: proc() {
	cstring_example()
}
