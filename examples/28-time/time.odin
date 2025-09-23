package main

import "core:fmt"
import "core:time"

main :: proc() {
	// Get the current time (UTC)
	now := time.now()
	fmt.println("Current time:", now)

	year, month, day := time.date(now)
	fmt.println("Date:", year, month, day)

	// Parse time from string
	time_str := "2023-12-25T15:30:45Z"
	parsed_time, consumed := time.rfc3339_to_time_utc(time_str)
	fmt.println("Parsed time:", parsed_time, "Consumed bytes:", consumed)

	// Difference between two times
	now = time.now()
	time.sleep(2 * time.Second)
	later := time.now()
	diff := time.diff(now, later)
	fmt.println("Time difference (seconds):", diff)
	fmt.println("Time difference (nanoseconds):", time.duration_nanoseconds(diff))
}
