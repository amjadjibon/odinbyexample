package main

import "core:fmt"
import "core:os/os2"

main :: proc() {
	r, w, pipeerr := os2.pipe()
	if pipeerr != nil {
		fmt.eprintln(pipeerr)
		os2.exit(2)
	}
	defer os2.close(r)

	p, procerr := os2.process_start({command = {"cat"}, stdin = r, stdout = os2.stdout})
	if procerr != nil {
		fmt.eprintln(procerr)
		os2.exit(2)
	}

	_, writeerr := os2.write_string(w, "hello world\n")
	if writeerr != nil {
		fmt.eprintln(writeerr)
		os2.exit(2)
	}
}
