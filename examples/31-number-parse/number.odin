package main

import "core:fmt"
import "core:strconv"


main :: proc() {
	answer := "42"
	num, ok := strconv.parse_int(answer, 10)
	if ok {
		fmt.println("The answer is", num)
	} else {
		fmt.println("Failed to parse the number")
	}

	pi_str := "3.14159"
	pi, pi_ok := strconv.parse_f64(pi_str)
	if pi_ok {
		fmt.println("Pi is approximately", pi)
	} else {
		fmt.println("Failed to parse the float number")
	}

	hex_str := "0xFF"
	hex_num, hex_ok := strconv.parse_int(hex_str, 0)
	if hex_ok {
		fmt.println("Hexadecimal", hex_str, "is", hex_num, "in decimal")
	} else {
		fmt.println("Failed to parse the hexadecimal number")
	}
}
