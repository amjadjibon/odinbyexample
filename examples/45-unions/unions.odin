package main

import "core:fmt"

Foo :: struct {
	foo: string,
}

Bar :: struct {
	bar: string,
}

FooBar :: union {
	Foo,
	Bar,
}

foo_bar :: proc(foobar: FooBar) -> Maybe(string) {
	foo, ok1 := foobar.(Foo)
	if ok1 {
		return foo.foo
	}

	bar, ok2 := foobar.(Bar)
	if ok2 {
		return bar.bar
	}
	return nil
}

main :: proc() {
	foo := Foo {
		foo = "Says Foo!",
	}
	bar := Bar {
		bar = "Says Bar!",
	}

	fmt.println(foo_bar(foo))
	fmt.println(foo_bar(bar))
}
