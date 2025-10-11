package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:sys/posix"
import win32 "core:sys/windows"


repl_run :: proc() {
	fmt.println("Calculator REPL - Enter expressions (type 'exit' to quit)")
	fmt.println("Supports: +, -, *, /, ^, ()")
	fmt.println()

	buf: [256]byte

	for {
		fmt.print("» ")

		n, err := os.read(os.stdin, buf[:])
		if err != 0 {
			break
		}

		input := strings.trim_space(string(buf[:n]))

		if input == "exit" || input == "quit" {
			break
		}

		if len(input) == 0 {
			continue
		}

		fmt.println(input)
	}
}

is_stdin_piped :: proc() -> bool {
	when ODIN_OS == .Windows {
		// On Windows, check if stdin is redirected
		handle := win32.GetStdHandle(win32.STD_INPUT_HANDLE)
		file_type := win32.GetFileType(handle)
		return file_type != win32.FILE_TYPE_CHAR
	} else {
		// On Unix-like systems, check if stdin is a terminal
		return posix.isatty(posix.STDIN_FILENO) == false
	}
}

read_args :: proc() -> string {
	input := strings.join(os.args[1:], " ")
	return strings.trim_space(input)
}

read_stdin :: proc() -> string {
	buf: [4096]byte
	result := strings.builder_make()

	for {
		n, err := os.read(os.stdin, buf[:])
		if err != 0 || n == 0 {
			break
		}
		strings.write_bytes(&result, buf[:n])
	}

	return strings.trim_space(strings.to_string(result))
}

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	if len(os.args) > 1 {
		input := read_args()
		defer delete(input)
		fmt.println(input)
	} else if is_stdin_piped() {
		input := read_stdin()
		defer delete(input)
		fmt.println(input)
	} else {
		repl_run()
	}
}
