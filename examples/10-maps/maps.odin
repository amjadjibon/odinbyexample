package main

import "core:fmt"

main :: proc() {
	m := make(map[string]int)
	defer delete(m)

	m["one"] = 1
	m["two"] = 2
	m["three"] = 3

	fmt.println("Map: ", m)
	fmt.println("Value for key 'two': ", m["two"])

	// Check if a key exists
	value, exists := m["four"]
	if exists {
		fmt.println("Value for key 'four': ", value)
	} else {
		fmt.println("Key 'four' does not exist")
	}

	three_in_map := "three" in m
	fmt.println("Does key 'three' exist? ", three_in_map)

	// Iterate over map
	for key, value in m {
		fmt.printfln("Key: %s, Value: %d", key, value)
	}
}
