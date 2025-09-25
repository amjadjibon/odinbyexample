package main

import "core:fmt"

main :: proc() {
	// Load a file
	foo := #load("test.txt")
	fmt.printf("%s", string(foo))

	hash := #hash("Hello, World!\n", "crc32")
	fmt.printf("Hash: %d\n", hash)

	hash = #load_hash("test.txt", "crc32")
	fmt.printf("File Hash: %d\n", hash)

	// Load all files in a directory
	bar := #load_directory("./test/subdir")
	for b in bar {
		fmt.printf("File Name: %s\n", b.name)
		fmt.printf("File Data: %s\n", b.data)
	}
}
