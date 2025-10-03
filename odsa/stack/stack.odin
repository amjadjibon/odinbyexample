package stack

import "core:fmt"

Stack :: struct($T: typeid) {
	data: [dynamic]T,
}

// Create a new empty stack
make_stack :: proc($T: typeid, allocator := context.allocator) -> Stack(T) {
	return Stack(T){data = make([dynamic]T, allocator)}
}

// Create a stack with initial capacity
make_stack_cap :: proc($T: typeid, capacity: int, allocator := context.allocator) -> Stack(T) {
	return Stack(T){data = make([dynamic]T, 0, capacity, allocator)}
}

// Push a value onto the stack
push :: proc(stack: ^Stack($T), value: T) {
	append(&stack.data, value)
}

// Pop a value from the stack
pop :: proc(stack: ^Stack($T)) -> (value: T, ok: bool) {
	if len(stack.data) == 0 {
		return {}, false
	}

	value = stack.data[len(stack.data) - 1]
	resize(&stack.data, len(stack.data) - 1)
	return value, true
}

// Peek at the top value without removing it
peek :: proc(stack: ^Stack($T)) -> (value: T, ok: bool) {
	if len(stack.data) == 0 {
		return {}, false
	}

	return stack.data[len(stack.data) - 1], true
}

// Check if the stack is empty
is_empty :: proc(stack: ^Stack($T)) -> bool {
	return len(stack.data) == 0
}

// Get the number of elements in the stack
size :: proc(stack: ^Stack($T)) -> int {
	return len(stack.data)
}

// Get the capacity of the stack
capacity :: proc(stack: ^Stack($T)) -> int {
	return cap(stack.data)
}

// Clear all elements from the stack
clear :: proc(stack: ^Stack($T)) {
	resize(&stack.data, 0)
}

// Destroy the stack and free memory
destroy :: proc(stack: ^Stack($T)) {
	delete(stack.data)
}

// Print the stack (for debugging)
print_stack :: proc(stack: ^Stack($T)) {
	fmt.print("Stack (top -> bottom): [")
	for i := len(stack.data) - 1; i >= 0; i -= 1 {
		fmt.print(stack.data[i])
		if i > 0 {
			fmt.print(", ")
		}
	}
	fmt.println("]")
}

// Example usage
main :: proc() {
	stack := make_stack(int)
	defer destroy(&stack)

	fmt.println("=== Stack Operations Demo ===\n")

	// Push elements
	fmt.println("Pushing: 10, 20, 30, 40, 50")
	push(&stack, 10)
	push(&stack, 20)
	push(&stack, 30)
	push(&stack, 40)
	push(&stack, 50)

	print_stack(&stack)
	fmt.printf("Size: %d, Capacity: %d\n\n", size(&stack), capacity(&stack))

	// Peek at top
	if val, ok := peek(&stack); ok {
		fmt.printf("Peek (top element): %d\n\n", val)
	}

	// Pop elements
	fmt.println("Popping elements:")
	for !is_empty(&stack) {
		if val, ok := pop(&stack); ok {
			fmt.printf("Popped: %d\n", val)
		}
	}

	fmt.printf("\nStack is empty: %v\n", is_empty(&stack))

	// Try to pop from empty stack
	if val, ok := pop(&stack); !ok {
		fmt.println("Cannot pop from empty stack")
	}

	// Push more elements
	fmt.println("\nPushing: 100, 200, 300")
	push(&stack, 100)
	push(&stack, 200)
	push(&stack, 300)
	print_stack(&stack)

	// Clear the stack
	fmt.println("\nClearing stack...")
	clear(&stack)
	fmt.printf("Stack is empty: %v\n", is_empty(&stack))

	// Example with strings
	fmt.println("\n=== String Stack ===")
	str_stack := make_stack(string)
	defer destroy(&str_stack)

	push(&str_stack, "Hello")
	push(&str_stack, "World")
	push(&str_stack, "Odin")

	print_stack(&str_stack)

	if val, ok := pop(&str_stack); ok {
		fmt.printf("Popped string: %s\n", val)
	}
	print_stack(&str_stack)
}
