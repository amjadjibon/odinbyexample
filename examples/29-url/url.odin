package url

import "core:fmt"

URL :: struct {
	Scheme:   string,
	User:     Userinfo,
	Host:     string,
	Path:     string,
	RawQuery: string,
	Fragment: string,
}

Userinfo :: struct {
	username: string,
	password: string,
}

Error :: enum {
	OK,
	InvalidURL,
	UnsupportedScheme,
	MissingHost,
}

supported_scheme :: []string{"http", "https", "ftp", "postgres"}

parse :: proc(rawurl: string) -> (URL, Error) {
	url := URL{}
	if rawurl == "" {
		return url, Error.InvalidURL
	}

	remaining := rawurl

	// Parse scheme
	supported := false
	if scheme_end := find_first(remaining, "://"); scheme_end != -1 {
		url.Scheme = remaining[:scheme_end]
		remaining = remaining[scheme_end + 3:]
		// Validate scheme
		for s in supported_scheme {
			if s == url.Scheme {
				supported = true
				break
			}
		}
	} else {
		supported = false
	}

	if !supported {
		return url, Error.UnsupportedScheme
	}

	// Parse fragment first (it's at the end)
	if fragment_start := find_first(remaining, "#"); fragment_start != -1 {
		url.Fragment = remaining[fragment_start + 1:]
		remaining = remaining[:fragment_start]
	}

	// Parse query
	if query_start := find_first(remaining, "?"); query_start != -1 {
		url.RawQuery = remaining[query_start + 1:]
		remaining = remaining[:query_start]
	}

	// Parse path (everything after first '/')
	if path_start := find_first(remaining, "/"); path_start != -1 {
		url.Path = remaining[path_start:]
		remaining = remaining[:path_start]
	}

	// Parse user info and host
	if at_pos := find_first(remaining, "@"); at_pos != -1 {
		userinfo_str := remaining[:at_pos]
		remaining = remaining[at_pos + 1:]

		// Parse username:password
		if colon_pos := find_first(userinfo_str, ":"); colon_pos != -1 {
			url.User.username = userinfo_str[:colon_pos]
			url.User.password = userinfo_str[colon_pos + 1:]
		} else {
			url.User.username = userinfo_str
		}
	}

	// Remaining is the host
	if remaining == "" {
		return url, Error.MissingHost
	}
	url.Host = remaining

	return url, Error.OK
}

find_first :: proc(s: string, substr: string) -> int {
	if len(substr) == 0 || len(substr) > len(s) {
		return -1
	}

	for i := 0; i <= len(s) - len(substr); i += 1 {
		match := true
		for j := 0; j < len(substr); j += 1 {
			if s[i + j] != substr[j] {
				match = false
				break
			}
		}
		if match {
			return i
		}
	}
	return -1
}

main :: proc() {
	urls := []string {
		"https://user:pass@localhost:8080/path?query=1#fragment",
		"postgres://user1@passwedb:5432/dbname?sslmode=disable",
		"ftp://ftp.example.com/resource.txt",
		"abc://adsf.com",
		"invalid-url",
	}
	for url_str in urls {
		url, err := parse(url_str)
		if err != Error.OK {
			fmt.printfln("Error parsing URL '%s': %v", url_str, err)
			continue
		}

		fmt.println("Scheme:", url.Scheme)
		fmt.println("User:", url.User.username)
		fmt.println("Password:", url.User.password)
		fmt.println("Host:", url.Host)
		fmt.println("Path:", url.Path)
		fmt.println("RawQuery:", url.RawQuery)
		fmt.println("Fragment:", url.Fragment)
	}
}
