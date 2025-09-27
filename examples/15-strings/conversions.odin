package main

import "core:fmt"
import "core:strings"

main :: proc() {
	// String to []u8
	st := "Hello, Odin!"
	stbytes := transmute([]u8)st
	fmt.println(stbytes)

	// Clone a string
	stcopy := strings.clone(st)
	fmt.println(stcopy)

	// Bytes to string
	stnew := string(stbytes)
	fmt.println(stnew)
}
