package main

import "core:fmt"
import "core:log"
import "core:os"

log_level :: proc() -> log.Level {
	log_level_env := os.get_env("LOG_LEVEL")

	switch log_level_env {
	case "DEBUG":
		return log.Level.Debug
	case "INFO":
		return log.Level.Info
	case "WARN":
		return log.Level.Warning
	case "ERROR":
		return log.Level.Error
	case:
		return log.Level.Info
	}
}

main :: proc() {
	log_level := log_level()
	fmt.printf("Log level: %s\n", log_level)
	logger := log.create_console_logger(log_level)
	context.logger = logger

	log_examples()
}

log_examples :: proc() {
	log.debug("This is debug log")
	log.info("This is info log")
	log.warn("This is warning log")
	log.error("This is error log")
}
