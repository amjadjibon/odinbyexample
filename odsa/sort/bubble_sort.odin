package sort

import "core:fmt"

bubble_sort :: proc(arr: []int) {
	n := len(arr)

	for i in 0 ..< n {
		swapped := false

		for j in 0 ..< (n - i - 1) {
			if arr[j] > arr[j + 1] {
				arr[j], arr[j + 1] = arr[j + 1], arr[j]
				swapped = true
			}
		}

		// If no swaps occurred, array is already sorted
		if !swapped {
			break
		}
	}
}
