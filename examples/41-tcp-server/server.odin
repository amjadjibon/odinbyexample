package main

import "core:fmt"
import "core:net"
import "core:strings"

main :: proc() {
	fmt.println("Setting up socket for our server")
	listen_socket, listen_err := net.listen_tcp(
		net.Endpoint{port = 8000, address = net.IP4_Loopback},
	)
	if listen_err != nil {
		fmt.panicf("Listen error: %s", listen_err)
	}
	defer net.close(listen_socket)

	fmt.println("Listening on port 8000")

	client_socket, client_endpoint, accept_err := net.accept_tcp(listen_socket)
	if accept_err != nil {
		fmt.panicf("Accept error: %s", accept_err)
	}
	defer net.close(client_socket)

	fmt.println("Client connected")
	fmt.println("Client endpoint:", client_endpoint)

	handle_connection(client_socket)
}

handle_connection :: proc(client_soc: net.TCP_Socket) {
	buf: [128]u8

	for {
		n, err := net.recv_tcp(client_soc, buf[:])
		if err != nil {
			fmt.println("Receive error (or client disconnected):", err)
			break
		}
		if n == 0 {
			fmt.println("Client closed connection")
			break
		}

		data_str := string(buf[:n])
		data_clean := strings.trim(data_str, " \t\r\n")

		if data_clean == "exit" {
			fmt.println("Exit command received. Closing connection.")
			break
		}

		fmt.println("Client said:", data_clean)
	}
}
