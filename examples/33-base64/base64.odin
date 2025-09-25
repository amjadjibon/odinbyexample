package main

import "core:encoding/base64"
import "core:fmt"

encode_decode_test :: proc() {
	input_str := "Hello, Odin!"
	input_bytes := transmute([]byte)input_str

	fmt.println("Original string:", input_str)
	fmt.println("Byte array:", input_bytes)

	encoded, encode_err := base64.encode(input_bytes)
	defer delete(encoded)
	assert(encode_err == nil)

	fmt.println("Base64 encoded:", encoded)

	decoded, decode_err := base64.decode(encoded)
	defer delete(decoded)
	assert(decode_err == nil)

	fmt.println(string(decoded))
}

main :: proc() {
	encode_decode_test()
}
