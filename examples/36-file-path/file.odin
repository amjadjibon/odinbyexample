package main

import "core:fmt"
import "core:path/filepath"

main :: proc() {
	path := "dir/subdir/file.txt"

	fmt.println("Base:", filepath.base(path))
	fmt.println("Dir:", filepath.dir(path))
	fmt.println("Ext:", filepath.ext(path))
	fmt.println("Name:", filepath.base(path))

	joined_path := filepath.join({"root", "folder", "another_file.dat"})
	fmt.println("Joined Path:", joined_path)
}
