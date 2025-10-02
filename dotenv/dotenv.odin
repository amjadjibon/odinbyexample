package dotenv

import "core:os"
import "core:strings"
import "core:unicode"

// Load .env file and set environment variables
load :: proc(filename := ".env", allocator := context.allocator) -> (ok: bool) {
	context.allocator = allocator

	data, read_ok := os.read_entire_file(filename)
	if !read_ok {
		return false
	}
	defer delete(data)

	content := string(data)
	lines := strings.split_lines(content)
	defer delete(lines)

	for line in lines {
		trimmed := strings.trim_space(line)

		// Skip empty lines and comments
		if len(trimmed) == 0 || strings.has_prefix(trimmed, "#") {
			continue
		}

		// Parse the line
		key, value, parse_ok := parse_line(trimmed)
		if parse_ok {
			os.set_env(key, value)
			delete(key)
			delete(value)
		}
	}

	return true
}

// Parse a single line from .env file
parse_line :: proc(line: string) -> (key: string, value: string, ok: bool) {
	// Find the equals sign
	eq_index := strings.index_byte(line, '=')
	if eq_index == -1 {
		return "", "", false
	}

	// Extract key
	key_str := strings.trim_space(line[:eq_index])
	if len(key_str) == 0 {
		return "", "", false
	}

	// Validate key (must be valid identifier)
	if !is_valid_key(key_str) {
		return "", "", false
	}

	// Extract value
	value_str := line[eq_index + 1:]
	value_str = strings.trim_space(value_str)

	// Parse value (handle quotes, escapes, etc.)
	parsed_value := parse_value(value_str)

	return strings.clone(key_str), parsed_value, true
}

// Check if key is valid (alphanumeric + underscore)
is_valid_key :: proc(key: string) -> bool {
	if len(key) == 0 {
		return false
	}

	for r in key {
		if !unicode.is_alpha(r) && !unicode.is_digit(r) && r != '_' {
			return false
		}
	}

	return true
}

// Parse value handling quotes and escape sequences
parse_value :: proc(value: string) -> string {
	if len(value) == 0 {
		return ""
	}

	// Check if value is quoted
	if len(value) >= 2 {
		first := value[0]
		last := value[len(value) - 1]

		// Handle double quotes
		if first == '"' && last == '"' {
			inner := value[1:len(value) - 1]
			return process_escapes(inner)
		}

		// Handle single quotes (no escape processing)
		if first == '\'' && last == '\'' {
			return strings.clone(value[1:len(value) - 1])
		}
	}

	// Unquoted value - trim inline comments
	result := value
	comment_index := strings.index_byte(result, '#')
	if comment_index != -1 {
		result = result[:comment_index]
	}

	return strings.clone(strings.trim_space(result))
}

// Process escape sequences in double-quoted strings
process_escapes :: proc(s: string) -> string {
	if !strings.contains(s, "\\") {
		return strings.clone(s)
	}

	builder := strings.builder_make()

	i := 0
	for i < len(s) {
		if s[i] == '\\' && i + 1 < len(s) {
			next := s[i + 1]
			switch next {
			case 'n':
				strings.write_byte(&builder, '\n')
				i += 2
			case 'r':
				strings.write_byte(&builder, '\r')
				i += 2
			case 't':
				strings.write_byte(&builder, '\t')
				i += 2
			case '\\':
				strings.write_byte(&builder, '\\')
				i += 2
			case '"':
				strings.write_byte(&builder, '"')
				i += 2
			case:
				// Unknown escape, keep backslash
				strings.write_byte(&builder, s[i])
				i += 1
			}
		} else {
			strings.write_byte(&builder, s[i])
			i += 1
		}
	}

	return strings.to_string(builder)
}
