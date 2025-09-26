package main

import "core:bufio"
import "core:fmt"
import "core:net"
import "core:os"
import "core:strings"

main :: proc() {
	fmt.println("Connecting to TCP server on localhost:8000")

	endpoint := net.Endpoint {
		port    = 8000,
		address = net.IP4_Loopback,
	}

	client_socket, dial_err := net.dial_tcp(endpoint)
	if dial_err != nil {
		fmt.panicf("Dial error: %s", dial_err)
	}
	defer net.close(client_socket)

	fmt.println("Connected to server!")
	fmt.println("Type messages to send to server (type 'exit' to quit)")

	send_messages(client_socket)
}

send_messages :: proc(client_socket: net.TCP_Socket) {
	reader: bufio.Reader
	buffer: [1024]byte
	bufio.reader_init_with_buf(&reader, os.stream_from_handle(os.stdin), buffer[:])
	defer bufio.reader_destroy(&reader)

	for {
		fmt.print("> ")

		input, input_err := bufio.reader_read_string(&reader, '\n', context.allocator)
		if input_err != nil {
			fmt.println("Input error:", input_err)
			break
		}
		defer delete(input, context.allocator)

		message := strings.trim(input, " \t\r\n")

		if message == "exit" {
			fmt.println("Sending exit command to server...")
			n, send_err := net.send_tcp(client_socket, transmute([]u8)message)
			if send_err != nil {
				fmt.println("Send error:", send_err)
			}
			break
		}

		if len(message) == 0 {
			continue
		}

		n, send_err := net.send_tcp(client_socket, transmute([]u8)message)
		if send_err != nil {
			fmt.println("Send error:", send_err)
			break
		}

		fmt.println("Sent:", message)
	}
}
