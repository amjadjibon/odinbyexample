package main

import "core:fmt"

maybe_answer :: proc(cond: bool) -> Maybe(int) {
	if cond {
		return 42
	}
	return nil
}

main :: proc() {
	answer := maybe_answer(true)
	if answer != nil {
		fmt.println(answer)
	} else {
		fmt.println("No answer")
	}

	answer2, ok := maybe_answer(false).?
	if ok {
		fmt.println(answer2)
	} else {
		fmt.println("No answer")
	}
}
