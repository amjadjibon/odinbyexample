package main

import "core:fmt"


Pair :: struct($T: typeid) {
	first:  T,
	second: T,
}

pair_to_str :: proc(p: $T/Pair) -> string {
	return fmt.tprintf("%v-%v", p.first, p.second)
}

Node :: struct($T: typeid) {
	value: T,
	next:  ^Node(T),
}

LinkedList :: struct($T: typeid) {
	head: ^Node(T),
}

print_linked_list :: proc(list: LinkedList($T)) {
	current := list.head
	for current != nil {
		fmt.printf("%v -> ", current.value)
		current = current.next
	}
	fmt.println("nil")
}

main :: proc() {
	p1 := Pair(int){1, 2}
	fmt.println("Pair of integers:", pair_to_str(p1))

	p2 := Pair(string){"hello", "world"}
	fmt.println("Pair of strings:", pair_to_str(p2))

	list := LinkedList(int){}
	list.head = &Node(int){value = 10, next = nil}
	list.head.next = &Node(int){value = 20, next = nil}
	list.head.next.next = &Node(int){value = 30, next = nil}
	fmt.println("Initial linked list:")
	print_linked_list(list)
}
