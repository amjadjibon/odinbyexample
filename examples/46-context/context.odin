package main

main :: proc() {
	c := context // copy the current scope's context

	context.user_index = 456
	assert(context.user_index == 456)
}

supertramp :: proc() {
	c := context
	user_index := c.user_index
	assert(user_index == 456)

	ptr := new(int)
	free(ptr)
}
