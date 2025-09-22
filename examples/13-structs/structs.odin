package main

import "core:fmt"

Cat :: struct {
	name:  string,
	age:   int,
	color: string,
}

new_cat :: proc(name: string, age: int, color: string) -> Cat {
	return Cat{name = name, age = age, color = color}
}

main :: proc() {
	// Creating an instance of Cat struct
	my_cat := Cat {
		name  = "Whiskers",
		age   = 3,
		color = "Tabby",
	}

	// Accessing struct fields
	fmt.println("Cat's Name:", my_cat.name)
	fmt.println("Cat's Age:", my_cat.age)
	fmt.println("Cat's Color:", my_cat.color)

	// Modifying struct fields
	my_cat.age += 1
	fmt.println("After a year, Cat's Age:", my_cat.age)

	// Creating another instance of Cat struct
	another_cat := new_cat("Mittens", 2, "Black")
	fmt.println("Another Cat's Name:", another_cat.name)
	fmt.println("Another Cat's Age:", another_cat.age)
	fmt.println("Another Cat's Color:", another_cat.color)
}
