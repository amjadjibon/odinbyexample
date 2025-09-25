package main

import "core:bufio"
import "core:fmt"
import "core:os"
import "core:strings"

read_whole_file :: proc(file_name: string) {
	data, ok := os.read_entire_file(file_name, context.allocator)
	if !ok {
		fmt.println("Error reading file")
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		fmt.println(line)
	}
}

read_file_buffer :: proc(file_name: string) {
	f, ferr := os.open(file_name)
	if ferr != 0 {
		fmt.println("Error opening file")
		return
	}
	defer os.close(f)

	r: bufio.Reader
	buffer: [1024]byte
	bufio.reader_init_with_buf(&r, os.stream_from_handle(f), buffer[:])
	// NOTE: bufio.reader_init can be used if you want to use a dynamic backing buffer
	defer bufio.reader_destroy(&r)

	for {
		// This will allocate a string because the line might go over the backing
		// buffer and thus need to join things together
		line, err := bufio.reader_read_string(&r, '\n', context.allocator)
		if err != nil {
			break
		}
		defer delete(line, context.allocator)
		line = strings.trim_right(line, "\r\n")
		fmt.println(line)
	}
}

main :: proc() {
	file_name := "file.odin"
	read_whole_file(file_name)
	read_file_buffer(file_name)
}
