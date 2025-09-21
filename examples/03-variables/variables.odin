package main

import "core:fmt"

main :: proc() {
	i := 42
	fmt.println("The value of i is", i)

	f := 3.14159
	fmt.println("The value of f is", f)
	fmt.printfln("The value of f with 2 decimal places is %.2f", f)

	s := "Hello, Odin!"
	fmt.println("The value of s is", s)

	b := true
	fmt.println("The value of b is", b)

	x: int
	fmt.println("The value of x is", x) // Default value for int is 0
}
