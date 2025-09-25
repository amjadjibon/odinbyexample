package main

import "core:crypto/hash"
import "core:encoding/hex"
import "core:fmt"

main :: proc() {
	input_str := "Hello, Odin!"
	input_bytes := input_str[:]
	digest_bytes := hash.hash(hash.Algorithm.SHA256, input_bytes)
	hash_hex := hex.encode(digest_bytes)
	fmt.println("SHA256:", string(hash_hex))
	assert(string(hash_hex) == "3bd3e94a918e4a999ed187695e9ee694cf55e4c1052ab3b5aeb70c53929274fb")
}
