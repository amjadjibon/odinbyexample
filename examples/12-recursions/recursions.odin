package main

import "core:fmt"

// Recursive function to calculate factorial of a number
fact :: proc(n: int) -> int {
	if n <= 1 {
		return 1
	}
	return n * fact(n - 1)
}

// Recursive function to calculate Fibonacci number
fib :: proc(n: int) -> int {
	if n <= 1 {
		return n
	}
	return fib(n - 1) + fib(n - 2)
}

main :: proc() {
	n := 5

	// Calculate factorial
	result := fact(n)
	fmt.println("Factorial of", n, "is", result)

	// Calculate Fibonacci numbers
	for i := 0; i < 10; i += 1 {
		fmt.println("Fibonacci(", i, ") =", fib(i))
	}
}
