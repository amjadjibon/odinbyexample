package main

import "core:fmt"

casting :: proc() {
	i := 123
	fmt.println("Value of i:", i)
	fmt.println("Type of i:", typeid_of(type_of(i)))

	f := cast(f64)i
	fmt.println("Value of f:", f)
	fmt.println("Type of f:", typeid_of(type_of(f)))

	u := cast(u32)f
	fmt.println("Value of u:", u)
	fmt.println("Type of u:", typeid_of(type_of(u)))
}

transmute_operator :: proc() {
	f := f32(123)
	fmt.println("Value of f:", f)
	fmt.println("Type of f:", typeid_of(type_of(f)))

	u := transmute(u32)f
	fmt.println("Value of u:", u)
	fmt.println("Type of u:", typeid_of(type_of(u)))
}

main :: proc() {
	// The expression T(v) converts the value v to the type T.
	i: int = 123
	fmt.println("Value of i:", i)
	fmt.println("Type of i:", typeid_of(type_of(i)))

	f: f64 = f64(i)
	fmt.println("Value of f:", f)
	fmt.println("Type of f:", typeid_of(type_of(f)))

	u: u32 = u32(f)
	fmt.println("Value of u:", u)
	fmt.println("Type of u:", typeid_of(type_of(u)))

	// Cast Opertator also does same
	casting()

	// Transmute operator
	// The transmute operator is a bit cast conversion between two types of the same size:
	transmute_operator()
}
