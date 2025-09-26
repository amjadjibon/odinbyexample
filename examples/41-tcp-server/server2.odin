package main

import "core:bytes"
import "core:fmt"
import "core:mem"
import "core:mem/virtual"
import "core:net"
import "core:strings"
import "core:sync"
import "core:thread"

// Client data structure to pass information between threads
// This contains the client socket and reference to the wait group for synchronization
clientData :: struct {
	client_socket: net.TCP_Socket, // The TCP socket for this specific client connection
	waitgroupdata: ^sync.Wait_Group, // Pointer to the wait group for thread synchronization
}

main :: proc() {
	fmt.println("=== TCP Server Starting ===")

	// MEMORY MANAGEMENT SETUP
	// Store the default allocator (usually the system allocator)
	default_allocator := context.allocator

	// Create a tracking allocator that wraps the default allocator
	// This allows us to monitor all memory allocations and detect leaks
	tracking_allocator: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, default_allocator)

	// Replace the context allocator with our tracking allocator
	// All subsequent allocations will go through the tracking allocator
	context.allocator = mem.tracking_allocator(&tracking_allocator)

	// Memory leak detection function
	// This will be called when the program exits to check for memory leaks
	reset_tracking_allocator :: proc(a: ^mem.Tracking_Allocator) -> bool {
		fmt.println("Memory Management: Checking for memory leaks...")
		err := false

		// Iterate through all unfreed allocations
		for _, val in a.allocation_map {
			fmt.printf("MEMORY LEAK: %v leaked %v bytes\n", val.location, val.size)
			err = true
		}

		if !err {
			fmt.println("Memory Management: No memory leaks detected!")
		}

		// Clear the tracking allocator
		mem.tracking_allocator_clear(a)
		return err
	}
	// Defer ensures this runs when main() exits, checking for leaks
	defer reset_tracking_allocator(&tracking_allocator)

	// THREADING SETUP
	// Wait group for synchronizing all client handler threads
	// This ensures the main thread waits for all client threads to finish
	wg: sync.Wait_Group

	// Dynamic array to keep track of all spawned threads
	// Initial capacity of 20 threads, but can grow dynamically
	threadPool := make([dynamic]^thread.Thread, 0, 20)
	defer {
		fmt.println("Threading: Cleaning up thread pool")
		delete(threadPool) // Free the dynamic array memory
	}

	// NETWORK SETUP
	fmt.println("Network: Setting up TCP server on localhost:8000")

	// Create a TCP listening socket on port 8000, loopback interface (127.0.0.1)
	listen_socket, listen_err := net.listen_tcp(
		net.Endpoint{port = 8000, address = net.IP4_Loopback},
	)
	if listen_err != nil {
		fmt.panicf("Network Error: Failed to create listening socket: %s", listen_err)
	}
	fmt.println("Network: TCP server listening on 127.0.0.1:8000")

	// MAIN SERVER LOOP
	fmt.println("Server: Entering main accept loop - ready for client connections")

	// Infinite loop to accept client connections
	for {
		fmt.println("Server: Waiting for client connection...")

		// THREADING: Increment wait group counter before creating thread
		// This tells the wait group to expect one more thread to complete
		sync.wait_group_add(&wg, 1)

		// Accept a new client connection (blocking call)
		client_soc, client_endpoint, accept_err := net.accept_tcp(listen_socket)
		if accept_err != nil {
			fmt.panicf("Network Error: Failed to accept client connection: %s", accept_err)
		}
		fmt.printf("Network: Client connected from %v\n", client_endpoint)

		// THREADING: Create a new thread to handle this client
		// Each client gets its own thread for concurrent handling
		thr := thread.create(handleClient)
		fmt.printf("Threading: Created new thread %p for client\n", thr)

		// MEMORY: Allocate client data structure and pass to thread
		// This data will be accessible in the thread's context
		client_data := &clientData{client_socket = client_soc, waitgroupdata = &wg}
		thr.data = client_data
		fmt.printf("Threading: Client data allocated and assigned to thread %p\n", thr)

		// Add thread to our tracking pool
		append(&threadPool, thr)
		fmt.printf(
			"Threading: Thread %p added to pool (total threads: %d)\n",
			thr,
			len(threadPool),
		)

		// Start the thread execution
		thread.start(thr)
		fmt.printf("Threading: Thread %p started and handling client\n", thr)
	}

	// Wait for all client threads to complete before exiting
	// This line will never be reached due to infinite loop above
	sync.wait_group_wait(&wg)
	fmt.println("Server: All client threads completed, shutting down")
}

// Client handler function - runs in its own thread for each client
handleClient :: proc(t: ^thread.Thread) {
	// THREADING: Extract client data from thread context
	client_data := (cast(^clientData)t.data)
	fmt.printf("Thread %p: Starting client handler\n", t)

	// MEMORY & THREADING: Cleanup when thread exits
	// This defer ensures proper cleanup regardless of how the function exits
	defer {
		fmt.printf("Thread %p: Cleaning up client connection\n", t)

		// Close the client socket to free network resources
		net.close(client_data.client_socket)
		fmt.printf("Thread %p: Client socket closed\n", t)

		// THREADING: Decrement wait group counter
		// This signals that this thread has completed its work
		sync.wait_group_done(client_data.waitgroupdata)
		fmt.printf("Thread %p: Wait group counter decremented\n", t)
	}

	fmt.printf("Thread %p: Entering client communication loop\n", t)

	// Client communication loop
	for {
		// MEMORY: Allocate buffer for incoming data on the stack
		// Stack allocation is faster and automatically cleaned up
		data_in_bytes: [8]byte
		fmt.printf("Thread %p: Allocated 8-byte buffer for client data\n", t)

		// Receive data from client (blocking call)
		bytes_received, err := net.recv_tcp(client_data.client_socket, data_in_bytes[:])
		if err != nil {
			// Handle different types of connection errors
			if err == .Connection_Closed {
				fmt.printf("Thread %p: Client disconnected gracefully\n", t)
				break
			}
			fmt.printf("Thread %p: Error receiving data: %s\n", t, err)
			break
		}

		// Handle case where client sends 0 bytes (connection closed)
		if bytes_received == 0 {
			fmt.printf("Thread %p: Client disconnected (0 bytes received)\n", t)
			break
		}

		fmt.printf("Thread %p: Received %d bytes from client\n", t, bytes_received)

		// Check for exit command
		// "exit\r\n" in byte format with padding
		exit_code := [8]byte{101, 120, 105, 116, 13, 10, 0, 0}
		if data_in_bytes == exit_code {
			fmt.printf("Thread %p: Client requested exit\n", t)

			// Send exit confirmation message
			exit_message := "you can exit now\r\n"
			net.send_tcp(client_data.client_socket, transmute([]byte)exit_message)
			fmt.printf("Thread %p: Sent exit confirmation to client\n", t)
			break
		}

		// Send acknowledgment to client
		acknowledgment := cast([]u8){'s', 'e', 'n', 't', '\n'}
		n, send_err := net.send_tcp(client_data.client_socket, acknowledgment)
		if send_err != nil {
			fmt.printf("Thread %p: Error sending acknowledgment: %s\n", t, send_err)
			break
		}
		fmt.printf("Thread %p: Sent %d byte acknowledgment to client\n", t, n)

		// MEMORY: Convert received bytes to string
		// This allocates memory on the heap using our tracking allocator
		data, string_err := strings.clone_from_bytes(
			data_in_bytes[:bytes_received],
			context.allocator, // Uses our tracking allocator
		)
		if string_err == nil {
			fmt.printf("Thread %p: Client said: '%s'\n", t, data)

			// MEMORY: Important! Free the allocated string memory
			// Without this, we'd have a memory leak for each client message
			delete(data, context.allocator)
			fmt.printf("Thread %p: Freed string memory\n", t)
		} else {
			fmt.printf("Thread %p: Error converting bytes to string: %s\n", t, string_err)
		}
	}

	fmt.printf("Thread %p: Exiting client handler\n", t)
}
