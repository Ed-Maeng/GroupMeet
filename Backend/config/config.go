package config

import (
	"fmt"
	"os"
	"time"

	"github.com/joho/godotenv"
)

// Config holds all the necessary database connection parameters.
type DBConfig struct {
	Host           string
	DBPort         string
	Name           string
	User           string
	Password       string
	AuthMethod     string
	MaxRetries     int
	InitialBackoff time.Duration
	MaxBackoff     time.Duration
}

// Config holds all the necessary app parameters.
type AppConfig struct {
	Port   string
	JWTKey string
}

// LoadCLoadDBConfigonfig loads DB configuration from a .env file and environment variables.
func LoadDBConfig() (*DBConfig, error) {
	// Attempt to load .env file. It's okay if it doesn't exist.
	_ = godotenv.Load(".env")

	cfg := &DBConfig{
		Host:       os.Getenv("DB_HOST"),
		DBPort:     os.Getenv("DB_PORT"),
		Name:       os.Getenv("DB_NAME"),
		User:       os.Getenv("DB_USER"),
		Password:   os.Getenv("DB_PASSWORD"),    // Primarily for local password auth
		AuthMethod: os.Getenv("DB_AUTH_METHOD"), // e.g., "password" or "token"

		// Default retry logic parameters
		MaxRetries:     5,
		InitialBackoff: 1 * time.Second,
		MaxBackoff:     30 * time.Second,
	}

	// Input Validation
	if cfg.Host == "" || cfg.DBPort == "" || cfg.Name == "" || cfg.User == "" || cfg.AuthMethod == "" {
		return nil, fmt.Errorf("missing one or more required environment variables from DB Config")
	}

	return cfg, nil
}

// LoadAppConfig loads App configuration from a .env file and environment variables.
func LoadAppConfig() (*AppConfig, error) {
	// Attempt to load .env file. It's okay if it doesn't exist.
	_ = godotenv.Load(".env")

	cfg := &AppConfig{
		Port:   os.Getenv("PORT"),
		JWTKey: os.Getenv("JWT_KEY"),
	}

	// Input Validation
	if cfg.Port == "" || cfg.JWTKey == "" {
		return nil, fmt.Errorf("missing one or more required environment variables from App Config")
	}

	return cfg, nil
}
