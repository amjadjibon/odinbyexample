package main

import "core:fmt"
import "core:text/regex"

main :: proc() {
	// Pattern to match email addresses
	pattern := `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}`

	// Compile regex
	re, err := regex.create(pattern)
	if err != nil {
		fmt.println("Regex compile error:", err)
		return
	}
	defer regex.destroy_regex(re)

	// Input string
	text := "Contact us at support@example.com or sales@example.com"

	// Iterate to find all matches
	emails: [dynamic]string
	defer delete(emails)

	start_pos := 0
	for {
		capture, ok := regex.match_and_allocate_capture(re, text[start_pos:])
		if !ok {
			break // No more matches
		}

		// Adjust positions for the original string
		match_text := capture.groups[0]
		match_start := capture.pos[0][0] + start_pos // Use [0] for start
		match_end := capture.pos[0][1] + start_pos // Use [1] for end

		fmt.printf("Match found: %s (pos=%d:%d)\n", match_text, match_start, match_end)
		append(&emails, match_text)

		// Update start_pos to search after the current match
		start_pos += capture.pos[0][1] // Use [1] for end
		regex.destroy_capture(capture)

		// Prevent infinite loop if no progress is made
		if start_pos >= len(text) {
			break
		}
	}

	fmt.println("All emails found:", emails)
}
