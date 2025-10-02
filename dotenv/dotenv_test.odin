package dotenv

import "core:fmt"
import "core:os"
import "core:testing"

@(test)
test_load_env_file :: proc(t: ^testing.T) {
	// Clean up env vars first
	defer {
		os.unset_env("DATABASE_URL")
		os.unset_env("API_KEY")
		os.unset_env("DEBUG")
		os.unset_env("PORT")
		os.unset_env("APP_NAME")
		os.unset_env("MAX_CONNECTIONS")
		os.unset_env("TIMEOUT")
		os.unset_env("ENABLE_LOGGING")
		os.unset_env("ENABLE_CACHE")
		os.unset_env("LOG_PATH")
		os.unset_env("MESSAGE")
		os.unset_env("EMPTY_VALUE")
		os.unset_env("HOST")
	}

	// Try both paths - relative to current dir and relative to dotenv dir
	ok := load(".env.test")
	testing.expect(t, ok, "Should load .env.test file")

	// Verify environment variables are set correctly
	db_url, found := os.lookup_env("DATABASE_URL")
	defer delete(db_url)
	testing.expect(t, found, "DATABASE_URL should be set")
	testing.expect(t, db_url == "postgres://localhost:5432/mydb", "DATABASE_URL should match")

	api_key, found2 := os.lookup_env("API_KEY")
	defer delete(api_key)
	testing.expect(t, found2, "API_KEY should be set")
	testing.expect(t, api_key == "secret_key_123", "API_KEY should match")

	debug, found3 := os.lookup_env("DEBUG")
	defer delete(debug)
	testing.expect(t, found3, "DEBUG should be set")
	testing.expect(t, debug == "true", "DEBUG should match")

	port, found4 := os.lookup_env("PORT")
	defer delete(port)
	testing.expect(t, found4, "PORT should be set")
	testing.expect(t, port == "8080", "PORT should match")

	app_name, found5 := os.lookup_env("APP_NAME")
	defer delete(app_name)
	testing.expect(t, found5, "APP_NAME should be set")
	testing.expect(t, app_name == "My Application", "APP_NAME should match")

	message, found6 := os.lookup_env("MESSAGE")
	defer delete(message)
	testing.expect(t, found6, "MESSAGE should be set")
	testing.expect(t, message == "Hello\nWorld", "MESSAGE should have escape sequences processed")

	host, found7 := os.lookup_env("HOST")
	defer delete(host)
	testing.expect(t, found7, "HOST should be set")
	testing.expect(t, host == "localhost", "HOST should trim inline comments")
}

@(test)
test_load_with_custom_allocator :: proc(t: ^testing.T) {
	// Use context.temp_allocator
	ok := load(".env.test", context.temp_allocator)

	defer {
		os.unset_env("DATABASE_URL")
		os.unset_env("API_KEY")
		os.unset_env("DEBUG")
		os.unset_env("PORT")
		os.unset_env("APP_NAME")
		os.unset_env("MAX_CONNECTIONS")
		os.unset_env("TIMEOUT")
		os.unset_env("ENABLE_LOGGING")
		os.unset_env("ENABLE_CACHE")
		os.unset_env("LOG_PATH")
		os.unset_env("MESSAGE")
		os.unset_env("EMPTY_VALUE")
		os.unset_env("HOST")
	}

	testing.expect(t, ok, "Should load with custom allocator")

	db_url, found := os.lookup_env("DATABASE_URL")
	defer delete(db_url)

	testing.expect(t, found, "DATABASE_URL should be set")

	free_all(context.temp_allocator)
}
