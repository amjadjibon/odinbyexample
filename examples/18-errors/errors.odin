package main

import "core:fmt"

// Returning an error string as part of multiple return values
might_fail :: proc(should_fail: bool) -> (int, string) {
	if should_fail {
		return 0, "An error occurred!"
	}
	return 42, ""
}

// Returning an error as boolean and using out parameter
might_fail2 :: proc(should_fail: bool) -> (res: int, ok: bool) {
	if should_fail {
		return 0, true
	}
	return 42, false
}


// Custom error struct
Error :: struct {
	message: string,
}

new_error :: proc(msg: string) -> ^Error {
	err := new(Error)
	err.message = msg
	return err
}

might_fail3 :: proc(should_fail: bool) -> (int, ^Error) {
	if should_fail {
		return 0, new_error("An error occurred!")
	}
	return 42, nil
}


main :: proc() {
	result, err := might_fail(false)
	if err != "" {
		fmt.println("Error:", err)
	} else {
		fmt.println("Success! Result is:", result)
	}

	result, err = might_fail(true)
	if err != "" {
		fmt.println("Error:", err)
	} else {
		fmt.println("Success! Result is:", result)
	}

	result2, ok := might_fail2(false)
	if ok {
		fmt.println("Error occurred in might_fail2")
	} else {
		fmt.println("Success! Result from might_fail2 is:", result2)
	}

	result2, ok = might_fail2(true)
	if ok {
		fmt.println("Error occurred in might_fail2")
	} else {
		fmt.println("Success! Result from might_fail2 is:", result2)
	}

	result3, err3 := might_fail3(false)
	if err3 != nil {
		fmt.println("Error:", err3.message)
	} else {
		fmt.println("Success! Result from might_fail3 is:", result3)
	}

	result3, err3 = might_fail3(true)
	if err3 != nil {
		fmt.println("Error:", err3.message)
	} else {
		fmt.println("Success! Result from might_fail3 is:", result3)
	}
}
