package main

import "core:fmt"

opponent_operator :: proc() {
	// if the element type supports it
	// Not support for '/', '%', or '%%' operations

	a := matrix[2, 2]i32{
		1, 2,
		3, 4,
	}

	b := matrix[2, 2]i32{
		-5, 1,
		9, -7,
	}

	c0 := a + b
	c1 := a - b
	c2 := a & b
	c3 := a | b
	c4 := a ~ b
	c5 := a &~ b

	fmt.println("a + b", c0)
	fmt.println("a - b", c1)
	fmt.println("a & b", c2)
	fmt.println("a | b", c3)
	fmt.println("a ~ b", c4)
	fmt.println("a &~ b", c5)
}

main :: proc() {
	m: matrix[2, 3]f32

	m = matrix[2, 3]f32{
		1, 9, -13,
		20, 5, -6,
	}

	fmt.println(m)
	fmt.println("m[1,2]=", m[1, 2]) // row 1, column 2

	a := matrix[2, 3]f32{
		2, 3, 1,
		4, 5, 0,
	}

	b := matrix[3, 2]f32{
		1, 2,
		3, 4,
		5, 6,
	}

	fmt.println("a", a)
	fmt.println("b", b)

	c := a * b
	#assert(type_of(c) == matrix[2, 2]f32)
	fmt.println("c = a * b", c)

	m2 := matrix[4, 4]f32{
		1, 2, 3, 4,
		5, 5, 4, 2,
		0, 1, 3, 0,
		0, 1, 4, 1,
	}

	v := [4]f32{1, 5, 4, 3}

	// treating `v` as a column vector
	fmt.println("m2 * v", m2 * v)

	// treating `v` as a row vector
	fmt.println("v * m2", v * m2)

	// Support with non-square matrices
	s := matrix[2, 4]f32{ 	// [4][2]f32 default layout
		2, 4, 3, 1,
		7, 8, 6, 5,
	}

	w := [2]f32{1, 2}
	r: [4]f32 = w * s
	fmt.println("r", r)

	opponent_operator()
}
