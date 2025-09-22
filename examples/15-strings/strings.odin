package main

import "core:fmt"

main :: proc() {
	s := "Hello, Odin!"
	fmt.println("String:", s)

	// Accessing characters in a string
	fmt.println("First character:", s[0])
	fmt.println("Substring (0-5):", s[0:5])

	// String length
	fmt.println("Length of string:", len(s))

	// Iterating over characters in a string
	for i in 0 ..< len(s) {
		fmt.println("Character at index", i, ":", s[i])
	}

	// Using range to iterate over characters
	for c in s {
		fmt.println("Character:", c)
	}

	// Strings are immutable, so we can't change them directly
	// s[0] = 'h' // This will cause a compile-time error

	// Creating a new string by concatenation (constant strings only)
	s1 :: "Hello, "
	s2 :: "Odin!"
	s3 := s1 + s2
	fmt.println("Concatenated String:", s3)

	// Chars
	c := 'A'
	fmt.println("Character:", c)
	fmt.println("Character as int:", int(c))

	x: rune = 'あ' // Unicode character
	fmt.println("Unicode Character:", x)
	fmt.println("Unicode Character as int:", int(x))
}
