package linkedlist

import "core:fmt"

// Node represents a node in a singly linked list
Node :: struct($T: typeid) {
	value: T,
	next:  ^Node(T),
}

// SinglyLinkedList represents a singly linked list
SinglyLinkedList :: struct($T: typeid) {
	size: int,
	head: ^Node(T),
}

// Create a new empty linked list
new_singly_linked_list :: proc($T: typeid) -> SinglyLinkedList(T) {
	return SinglyLinkedList(T){}
}

// Push a value to the front of the list
push_front :: proc(list: ^SinglyLinkedList($T), value: T) {
	new_node := new(Node(T))
	new_node.value = value
	new_node.next = list.head
	list.head = new_node
	list.size += 1
}

// Push a value to the back of the list
push_back :: proc(list: ^SinglyLinkedList($T), value: T) {
	new_node := new(Node(T))
	new_node.value = value
	new_node.next = nil

	if list.head == nil {
		list.head = new_node
	} else {
		current := list.head
		for current.next != nil {
			current = current.next
		}
		current.next = new_node
	}
	list.size += 1
}

// Pop a value from the front of the list
pop_front :: proc(list: ^SinglyLinkedList($T)) -> (value: T, ok: bool) {
	if list.head == nil {
		return {}, false
	}

	node := list.head
	value = node.value
	list.head = node.next
	free(node)
	list.size -= 1
	return value, true
}

// Pop a value from the back of the list
pop_back :: proc(list: ^SinglyLinkedList($T)) -> (value: T, ok: bool) {
	if list.head == nil {
		return {}, false
	}

	if list.head.next == nil {
		value = list.head.value
		free(list.head)
		list.head = nil
		list.size -= 1
		return value, true
	}

	current := list.head
	for current.next.next != nil {
		current = current.next
	}

	value = current.next.value
	free(current.next)
	current.next = nil
	list.size -= 1
	return value, true
}

// Get the value at a specific index
get :: proc(list: ^SinglyLinkedList($T), index: int) -> (value: T, ok: bool) {
	if index < 0 || index >= list.size {
		return {}, false
	}

	current := list.head
	for i := 0; i < index; i += 1 {
		current = current.next
	}
	return current.value, true
}

// Insert a value at a specific index
insert_at :: proc(list: ^SinglyLinkedList($T), index: int, value: T) -> bool {
	if index < 0 || index > list.size {
		return false
	}

	if index == 0 {
		push_front(list, value)
		return true
	}

	new_node := new(Node(T))
	new_node.value = value

	current := list.head
	for i := 0; i < index - 1; i += 1 {
		current = current.next
	}

	new_node.next = current.next
	current.next = new_node
	list.size += 1
	return true
}

// Remove a value at a specific index
remove_at :: proc(list: ^SinglyLinkedList($T), index: int) -> (value: T, ok: bool) {
	if index < 0 || index >= list.size {
		return {}, false
	}

	if index == 0 {
		return pop_front(list)
	}

	current := list.head
	for i := 0; i < index - 1; i += 1 {
		current = current.next
	}

	node := current.next
	value = node.value
	current.next = node.next
	free(node)
	list.size -= 1
	return value, true
}

// Clear the list and free all nodes
clear :: proc(list: ^SinglyLinkedList($T)) {
	current := list.head
	for current != nil {
		next := current.next
		free(current)
		current = next
	}
	list.head = nil
	list.size = 0
}

// Destroy the list and free all nodes
destroy :: proc(list: ^SinglyLinkedList($T)) {
	clear(list)
	free(list)
}

// Print the list (for debugging)
print_list :: proc(list: ^SinglyLinkedList($T)) {
	fmt.print("[")
	current := list.head
	for current != nil {
		fmt.print(current.value)
		if current.next != nil {
			fmt.print(" -> ")
		}
		current = current.next
	}
	fmt.println("]")
}

// Example usage
main :: proc() {
	list := new_singly_linked_list(int)
	defer clear(&list)

	// Add elements
	push_back(&list, 10)
	push_back(&list, 20)
	push_back(&list, 30)
	push_front(&list, 5)

	fmt.println("List after additions:")
	print_list(&list)
	fmt.printf("Size: %d\n\n", list.size)

	// Insert at index
	insert_at(&list, 2, 15)
	fmt.println("After inserting 15 at index 2:")
	print_list(&list)

	// Get value at index
	if val, ok := get(&list, 2); ok {
		fmt.printf("Value at index 2: %d\n\n", val)
	}

	// Remove from front
	if val, ok := pop_front(&list); ok {
		fmt.printf("Popped from front: %d\n", val)
	}

	print_list(&list)
}
