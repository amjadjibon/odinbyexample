package main

import "core:fmt"
import "core:math/rand"


main :: proc() {
	random_uint := rand.uint32()
	fmt.println("Random Integer:", random_uint)

	random_int := rand.int31()
	fmt.println("Random Signed Integer:", random_int)

	random_float := rand.float32()
	fmt.println("Random Float:", random_float)

	random_in_range := rand.int_max(100)
	fmt.println("Random Integer in range 0-100:", random_in_range)

	random_float_in_range := rand.float64_range(10.0, 10.5)
	fmt.println("Random Float in range 10.0-20.0:", random_float_in_range)
}
