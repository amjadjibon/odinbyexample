package main

import "core:encoding/json"
import "core:fmt"

User :: struct {
	name:  string,
	age:   int,
	email: string,
}

main :: proc() {
	// Unmarshalling JSON string to struct
	json_str := `{"name": "Alice", "age": 30, "email": "admin@email.com"}`

	// Declare the user variable
	user: User

	// Parse JSON string into User struct
	unmarshal_err := json.unmarshal_string(json_str, &user)
	if unmarshal_err != nil {
		fmt.println("JSON unmarshal error:", unmarshal_err)
		return
	}

	// Print the parsed user
	fmt.println("User:", user)

	// Marshalling struct to JSON string
	json_bytes, marshal_err := json.marshal(user)
	if marshal_err != nil {
		fmt.println("JSON marshal error:", marshal_err)
		return
	}

	// Convert bytes to string for printing
	json_output := string(json_bytes)
	fmt.println("JSON output:", json_output)

	// Marshal and Unmarshal in map
	m: map[string]json.Value
	defer delete(m)

	fmt.println("Map before unmarshal:", m)

	unmarshal_err = json.unmarshal_string(json_str, &m)
	if unmarshal_err != nil {
		fmt.println("JSON unmarshal to map error:", unmarshal_err)
		return
	}

	fmt.println("Map after unmarshal:", m)

	// Accessing values in the map
	name_value, ok := m["name"]
	if ok {
		name, ok := name_value.(string)
		if ok {
			fmt.println("Name from map:", name)
		} else {
			fmt.println("Name is not a string")
		}
	} else {
		fmt.println("Name key not found in map")
	}

	// Marshal the map back to JSON
	json_bytes, marshal_err = json.marshal(m)
	if marshal_err != nil {
		fmt.println("JSON marshal map error:", marshal_err)
		return
	}

	json_output = string(json_bytes)
	fmt.println("JSON output from map:", json_output)
}
