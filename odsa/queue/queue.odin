package queue

import "core:fmt"

Queue :: struct($T: typeid) {
	data: [dynamic]T,
}

// Create a new empty queue
make_queue :: proc($T: typeid, allocator := context.allocator) -> Queue(T) {
	return Queue(T){data = make([dynamic]T, allocator)}
}

// Create a queue with initial capacity
make_queue_cap :: proc($T: typeid, capacity: int, allocator := context.allocator) -> Queue(T) {
	return Queue(T){data = make([dynamic]T, 0, capacity, allocator)}
}

// Enqueue (add) a value to the back of the queue
enqueue :: proc(queue: ^Queue($T), value: T) {
	append(&queue.data, value)
}

// Dequeue (remove) a value from the front of the queue
dequeue :: proc(queue: ^Queue($T)) -> (value: T, ok: bool) {
	if len(queue.data) == 0 {
		return {}, false
	}

	value = queue.data[0]
	ordered_remove(&queue.data, 0)
	return value, true
}

// Peek at the front value without removing it
peek_front :: proc(queue: ^Queue($T)) -> (value: T, ok: bool) {
	if len(queue.data) == 0 {
		return {}, false
	}

	return queue.data[0], true
}

// Peek at the back value without removing it
peek_back :: proc(queue: ^Queue($T)) -> (value: T, ok: bool) {
	if len(queue.data) == 0 {
		return {}, false
	}

	return queue.data[len(queue.data) - 1], true
}

// Check if the queue is empty
is_empty :: proc(queue: ^Queue($T)) -> bool {
	return len(queue.data) == 0
}

// Get the number of elements in the queue
size :: proc(queue: ^Queue($T)) -> int {
	return len(queue.data)
}

// Get the capacity of the queue
capacity :: proc(queue: ^Queue($T)) -> int {
	return cap(queue.data)
}

// Clear all elements from the queue
clear :: proc(queue: ^Queue($T)) {
	clear(&queue.data)
}

// Destroy the queue and free memory
destroy :: proc(queue: ^Queue($T)) {
	delete(queue.data)
}

// Print the queue (for debugging)
print_queue :: proc(queue: ^Queue($T)) {
	fmt.print("Queue (front -> back): [")
	for val, i in queue.data {
		fmt.print(val)
		if i < len(queue.data) - 1 {
			fmt.print(", ")
		}
	}
	fmt.println("]")
}

// Example usage
main :: proc() {
	queue := make_queue(int)
	defer destroy(&queue)

	fmt.println("=== Queue Operations Demo ===\n")

	// Enqueue elements
	fmt.println("Enqueuing: 10, 20, 30, 40, 50")
	enqueue(&queue, 10)
	enqueue(&queue, 20)
	enqueue(&queue, 30)
	enqueue(&queue, 40)
	enqueue(&queue, 50)

	print_queue(&queue)
	fmt.printf("Size: %d, Capacity: %d\n\n", size(&queue), capacity(&queue))

	// Peek at front and back
	if val, ok := peek_front(&queue); ok {
		fmt.printf("Peek front: %d\n", val)
	}
	if val, ok := peek_back(&queue); ok {
		fmt.printf("Peek back: %d\n\n", val)
	}

	// Dequeue elements
	fmt.println("Dequeuing elements:")
	for i := 0; i < 3; i += 1 {
		if val, ok := dequeue(&queue); ok {
			fmt.printf("Dequeued: %d\n", val)
			print_queue(&queue)
		}
	}

	fmt.printf("\nSize after dequeuing: %d\n", size(&queue))
	fmt.printf("Queue is empty: %v\n\n", is_empty(&queue))

	// Enqueue more elements
	fmt.println("Enqueuing: 60, 70")
	enqueue(&queue, 60)
	enqueue(&queue, 70)
	print_queue(&queue)

	// Dequeue all remaining elements
	fmt.println("\nDequeuing all remaining elements:")
	for !is_empty(&queue) {
		if val, ok := dequeue(&queue); ok {
			fmt.printf("Dequeued: %d\n", val)
		}
	}

	fmt.printf("\nQueue is empty: %v\n", is_empty(&queue))

	// Try to dequeue from empty queue
	if val, ok := dequeue(&queue); !ok {
		fmt.println("Cannot dequeue from empty queue")
	}

	// Example with strings
	fmt.println("\n=== String Queue ===")
	str_queue := make_queue(string)
	defer destroy(&str_queue)

	enqueue(&str_queue, "First")
	enqueue(&str_queue, "Second")
	enqueue(&str_queue, "Third")

	print_queue(&str_queue)

	if val, ok := dequeue(&str_queue); ok {
		fmt.printf("Dequeued string: %s\n", val)
	}
	print_queue(&str_queue)
}
