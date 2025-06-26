package database

import (
	"context"
	"fmt"
	"log"
	"math"
	"time"

	"groupmeet/config"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/policy"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/jackc/pgx/v5"
)

// Conn holds the single, package-level database connection
var Conn *pgx.Conn

// --- Helper Functions ---

// getAzureADToken retrieves an Azure AD access token for database authentication
func getAzureADToken(ctx context.Context) (string, error) {
	log.Println("Requesting Azure AD token using Managed Identity...")
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		return "", fmt.Errorf("failed to create default Azure credential: %w", err)
	}

	opts := policy.TokenRequestOptions{
		Scopes: []string{"https://ossrdbms-aad.database.windows.net/.default"},
	}

	token, err := cred.GetToken(ctx, opts)
	if err != nil {
		return "", fmt.Errorf("failed to get AAD token: %w", err)
	}
	return token.Token, nil
}

// getBackoffDuration calculates the sleep time for the next retry attempt.
func getBackoffDuration(attempt int, initial, max time.Duration) time.Duration {
	// Exponential backoff: initial * 2^attempt
	backoff := float64(initial) * math.Pow(2, float64(attempt))
	sleep := time.Duration(backoff)

	if sleep > max {
		return max
	}
	return sleep
}

// --- Main Connection Logic ---

// Connect initializes the database connection using the loaded configuration
func Connect() error {
	cfg, err := config.LoadDBConfig()
	if err != nil {
		return fmt.Errorf("error loading DB configuration: %w", err)
	}

	var lastErr error
	for i := 0; i < cfg.MaxRetries; i++ {
		log.Printf("Attempt %d of %d to connect to the database...", i+1, cfg.MaxRetries)

		// Create a context with a timeout for this specific attempt
		ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
		defer cancel()

		var password string
		if cfg.AuthMethod == "password" {
			password = cfg.Password
		} else {
			token, err := getAzureADToken(ctx)
			if err != nil {
				lastErr = err
				log.Printf("Attempt %d: Failed to get token: %v. Retrying...", i+1, err)
				time.Sleep(getBackoffDuration(i, cfg.InitialBackoff, cfg.MaxBackoff))
				continue
			}
			password = token
		}

		connStr := fmt.Sprintf("host=%s port=%s dbname=%s user=%s password=%s sslmode=require",
			cfg.Host, cfg.DBPort, cfg.Name, cfg.User, password)

		// Attempt to connect and ping
		Conn, lastErr = pgx.Connect(ctx, connStr)
		if lastErr == nil {
			if lastErr = Conn.Ping(ctx); lastErr == nil {
				log.Println("Successfully connected to Azure PostgreSQL!")
				return nil // Success!
			}
			// If ping fails, close the bad connection before retrying
			Close()
		}

		log.Printf("Attempt %d: Failed to connect or ping: %v. Retrying...", i+1, lastErr)
		time.Sleep(getBackoffDuration(i, cfg.InitialBackoff, cfg.MaxBackoff))
	}

	return fmt.Errorf("failed to connect to the database after %d retries: %w", cfg.MaxRetries, lastErr)
}

// Close gracefully closes the global database connection
func Close() {
	if Conn != nil {
		Conn.Close(context.Background())
		log.Println("Database connection has been closed.")
	}
}
