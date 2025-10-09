package main

import "core:crypto"
import "core:encoding/uuid"
import "core:fmt"

main :: proc() {
	context.random_generator = crypto.random_generator()
	id := uuid.generate_v4()
	id_str := uuid.to_string(id)
	defer delete(id_str)
	fmt.println("UUID4:", id_str)

	id7 := uuid.generate_v7()
	id7_str := uuid.to_string(id7)
	defer delete(id7_str)
	fmt.println("UUID7:", id7_str)
}
