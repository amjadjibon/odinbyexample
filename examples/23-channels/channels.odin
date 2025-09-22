package main

import "core:encoding/uuid"
import "core:fmt"
import "core:sync"
import "core:sync/chan"
import "core:thread"
import "core:time"


MessageData :: struct {
	wg:        ^sync.Wait_Group,
	requests:  ^chan.Chan(int), // client → server
	responses: ^chan.Chan(string), // server → client
}

main :: proc() {
	wg: sync.Wait_Group

	// Create request and response channels
	req_ch, _ := chan.create(chan.Chan(int), context.allocator)
	res_ch, _ := chan.create(chan.Chan(string), context.allocator)

	defer chan.destroy(&req_ch)
	defer chan.destroy(&res_ch)

	// Create server and client threads
	server := thread.create(run_server)
	client := thread.create(run_client)

	data := MessageData {
		wg        = &wg,
		requests  = &req_ch,
		responses = &res_ch,
	}
	server.data = &data
	client.data = &data

	server.init_context = context
	client.init_context = context

	sync.wait_group_add(&wg, 2)
	thread.start(server)
	thread.start(client)
	sync.wait_group_wait(&wg)

	fmt.println("Main: all done")
}

// Server thread: listens for requests and sends responses
run_server :: proc(t: ^thread.Thread) {
	d := cast(^MessageData)t.data
	for i in 0 ..< 3 {
		req, _ := chan.recv(d.requests^)
		fmt.printf("Server: got request %d\n", req)
		time.sleep(500 * time.Millisecond)
		resp := fmt.tprintf("Response to %d", req)
		chan.send(d.responses^, resp)
	}
	sync.wait_group_done(d.wg)
}

// Client thread: sends requests and waits for responses
run_client :: proc(t: ^thread.Thread) {
	d := cast(^MessageData)t.data
	for i in 1 ..= 3 {
		fmt.printf("Client: sending request %d\n", i)
		chan.send(d.requests^, i)

		resp, _ := chan.recv(d.responses^)
		fmt.printf("Client: got '%s'\n", resp)
	}
	sync.wait_group_done(d.wg)
}
