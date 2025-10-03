package main

import "core:fmt"

Color :: enum {
	Red,
	Green,
	Blue,
}

color_to_string :: proc(c: Color) -> string {
	switch c {
	case Color.Red:
		return "Red"
	case Color.Green:
		return "Green"
	case Color.Blue:
		return "Blue"
	case:
		return "Unknown"
	}
}

HttpStatus :: enum {
	Ok                  = 200,
	NotFound            = 404,
	InternalServerError = 500,
}

http_request :: struct {
	method: string,
	url:    string,
}

http_response :: struct {
	status: HttpStatus,
	body:   string,
}

request_handler :: proc(req: http_request) -> http_response {
	// Simulate handling a request
	if req.url == "/notfound" {
		return http_response{status = HttpStatus.NotFound, body = "404 Not Found"}
	} else if req.url == "/error" {
		return http_response {
			status = HttpStatus.InternalServerError,
			body = "500 Internal Server Error",
		}
	} else {
		return http_response{status = HttpStatus.Ok, body = "200 OK"}
	}
}

main :: proc() {
	c1 := Color.Red
	c2 := Color.Green
	c3 := Color.Blue

	fmt.println("Color 1:", color_to_string(c1))
	fmt.println("Color 2:", color_to_string(c2))
	fmt.println("Color 3:", color_to_string(c3))

	req1 := http_request {
		method = "GET",
		url    = "/",
	}
	res1 := request_handler(req1)
	fmt.println("Request 1 - Status:", res1.status, "Body:", res1.body)

	req2 := http_request {
		method = "GET",
		url    = "/notfound",
	}
	res2 := request_handler(req2)
	fmt.println("Request 2 - Status:", res2.status, "Body:", res2.body)

	req3 := http_request {
		method = "GET",
		url    = "/error",
	}
	res3 := request_handler(req3)
	fmt.println("Request 3 - Status:", res3.status, "Body:", res3.body)
}
