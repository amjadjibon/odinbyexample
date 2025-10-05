package sort

import "core:slice"
import "core:testing"

@(test)
test_bubble_sort_basic :: proc(t: ^testing.T) {
	arr := []int{64, 34, 25, 12, 22, 11, 90}
	expected := []int{11, 12, 22, 25, 34, 64, 90}

	bubble_sort(arr)

	testing.expect(t, slice.equal(arr, expected), "Bubble sort failed on basic test")
}

@(test)
test_bubble_sort_empty :: proc(t: ^testing.T) {
	arr := []int{}
	bubble_sort(arr)
	testing.expect(t, len(arr) == 0, "Bubble sort failed on empty array")
}

@(test)
test_bubble_sort_single :: proc(t: ^testing.T) {
	arr := []int{42}
	expected := []int{42}

	bubble_sort(arr)

	testing.expect(t, slice.equal(arr, expected), "Bubble sort failed on single element")
}

@(test)
test_bubble_sort_already_sorted :: proc(t: ^testing.T) {
	arr := []int{1, 2, 3, 4, 5}
	expected := []int{1, 2, 3, 4, 5}

	bubble_sort(arr)

	testing.expect(t, slice.equal(arr, expected), "Bubble sort failed on already sorted array")
}

@(test)
test_bubble_sort_reverse :: proc(t: ^testing.T) {
	arr := []int{5, 4, 3, 2, 1}
	expected := []int{1, 2, 3, 4, 5}

	bubble_sort(arr)

	testing.expect(t, slice.equal(arr, expected), "Bubble sort failed on reverse sorted array")
}
