package main

import "core:fmt"
import "core:os"
import "core:path/filepath"

main :: proc() {
	dir :: "test"
	err := os.make_directory(dir, 0o775)
	if err == nil {
		fmt.println("Directory created successfully")
	} else if err == os.EEXIST {
		fmt.println("Directory already exists")
	} else {
		fmt.println("Error creating directory:", err)
		return
	}

	err = os.make_directory(dir + "/subdir", 0o775)
	if err == nil {
		fmt.println("Subdirectory created successfully")
	} else if err == os.EEXIST {
		fmt.println("Subdirectory already exists")
	} else {
		fmt.println("Error creating subdirectory:", err)
		return
	}

	// delete dirs
	subdir := dir + "/subdir"
	err = os.remove(subdir)
	if err == nil {
		fmt.println("Subdirectory deleted successfully")
	} else if err == os.ENOENT {
		fmt.println("Subdirectory does not exist")
	} else {
		fmt.println("Error deleting subdirectory:", err)
		return
	}

	err = os.remove(dir)
	if err == nil {
		fmt.println("Directory deleted successfully")
	} else if err == os.ENOENT {
		fmt.println("Directory does not exist")
	} else {
		fmt.println("Error deleting directory:", err)
		return
	}
}
