package main

import "core:fmt"
import "core:io"
import "core:os"

write_file :: proc(file_path: string, content: string) {
	content_bytes := transmute([]byte)(content) // 'transmute' casts our string to a byte array
	ok := os.write_entire_file(file_path, content_bytes)
	if !ok {
		fmt.println("Error writing file")
	}
}

append_content :: proc(file_path: string, content: string) {
	content_bytes := transmute([]byte)(content) // 'transmute' casts our string to a byte array
	file, err := os.open(file_path, os.O_APPEND | os.O_WRONLY)
	if err != nil {
		fmt.println("Error opening file")
		return
	}
	defer os.close(file)

	n, write_err := os.write(file, content_bytes)
	if write_err != nil {
		fmt.println("Error writing to file")
	}
	fmt.printfln("Written %d bytes", n)
}

main :: proc() {
	file_path := "hello.txt"
	content := "Hello, world!"
	write_file(file_path, content)

	append_content(file_path, " How are you?\n")
	append_content(file_path, "I'm fine, thank you!\n")
}
