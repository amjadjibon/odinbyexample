package main

import "core:fmt"

Foo :: enum {
	A,
	B,
	C,
	D,
}

main :: proc() {
    f := Foo.A
    switch f {
    case .A: fmt.println("A")
    case .B: fmt.println("B")
    case .C: fmt.println("C")
    case .D: fmt.println("D")
    case:    fmt.println("?")
    }

    #partial switch f {
    case .A: fmt.println("A")
    case .D: fmt.println("D")
    }
}
