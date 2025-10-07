package lru

import container_lru "core:container/lru"
import "core:fmt"

main :: proc() {
	// Create an LRU cache with capacity of 3
	cache: container_lru.Cache(string, int)
	container_lru.init(&cache, capacity = 3)
	defer container_lru.destroy(&cache, call_on_remove = false)

	fmt.println("=== LRU Cache Example ===\n")

	// Set some values
	fmt.println("Adding entries:")
	container_lru.set(&cache, "one", 1)
	fmt.println("  set('one', 1)")
	container_lru.set(&cache, "two", 2)
	fmt.println("  set('two', 2)")
	container_lru.set(&cache, "three", 3)
	fmt.println("  set('three', 3)")
	fmt.printf("  Cache count: %d/%d\n\n", cache.count, cache.capacity)

	// Get a value (marks as recently used)
	fmt.println("Getting values:")
	if val, ok := container_lru.get(&cache, "one"); ok {
		fmt.printf("  get('one') = %d\n", val)
	}
	if val, ok := container_lru.get(&cache, "two"); ok {
		fmt.printf("  get('two') = %d\n\n", val)
	}

	// Add a fourth item - should evict "three" (least recently used)
	fmt.println("Adding fourth entry (capacity = 3):")
	container_lru.set(&cache, "four", 4)
	fmt.println("  set('four', 4)")
	fmt.println("  'three' should be evicted\n")

	// Check if entries exist
	fmt.println("Checking existence:")
	fmt.printf("  exists('one'): %v\n", container_lru.exists(&cache, "one"))
	fmt.printf("  exists('two'): %v\n", container_lru.exists(&cache, "two"))
	fmt.printf("  exists('three'): %v (evicted)\n", container_lru.exists(&cache, "three"))
	fmt.printf("  exists('four'): %v\n\n", container_lru.exists(&cache, "four"))

	// Peek without updating access
	fmt.println("Peeking (doesn't update usage):")
	if val, ok := container_lru.peek(&cache, "one"); ok {
		fmt.printf("  peek('one') = %d\n\n", val)
	}

	// Update existing value
	fmt.println("Updating existing value:")
	container_lru.set(&cache, "one", 100)
	if val, ok := container_lru.get(&cache, "one"); ok {
		fmt.printf("  set('one', 100), get('one') = %d\n\n", val)
	}

	// Remove an entry
	fmt.println("Removing entry:")
	removed := container_lru.remove(&cache, "two")
	fmt.printf("  remove('two'): %v\n", removed)
	fmt.printf("  Cache count: %d/%d\n\n", cache.count, cache.capacity)

	// Using get_ptr to modify value in place
	fmt.println("Modifying value in place:")
	if ptr, ok := container_lru.get_ptr(&cache, "four"); ok {
		fmt.printf("  Before: four = %d\n", ptr^)
		ptr^ = 400
		fmt.printf("  After: four = %d\n\n", ptr^)
	}

	// Clear the cache
	fmt.println("Clearing cache:")
	container_lru.clear(&cache, call_on_remove = false)
	fmt.printf("  Cache count after clear: %d\n", cache.count)
}
