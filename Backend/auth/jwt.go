package auth

import (
	"fmt"
	"log"
	"time"

	"groupmeet/config"

	"github.com/golang-jwt/jwt/v5"
)

// The secret key used to sign and verify JWTs.
// It is initialized in the init() function below.
var jwtKey []byte

// Runs automatically when the package is first used.
// It's the idiomatic Go way to handle package-level initialization.
func init() {
	cfg, err := config.LoadAppConfig()
	if err != nil {
		log.Fatalf("FATAL: Could not load app configuration for JWT setup: %v", err)
	}
	jwtKey = []byte(cfg.JWTKey)
}

// Defines the structure of the token's payload.
// We embed jwt.RegisteredClaims to include standard claims like expiration (ExpiresAt),
// and add our own custom claims like the UserID.
type CustomClaims struct {
	UserID int `json:"user_id"`
	jwt.RegisteredClaims
}

// Creates a new signed JWT string for a given user ID.
// The token will be valid for 24 hours.
func GenerateToken(userID int) (string, error) {
	// Set the expiration time for the token
	expirationTime := time.Now().Add(24 * time.Hour)

	// Create the claims with our custom data and standard expiration
	claims := &CustomClaims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			Issuer:    "groupmeet-api", // Optional: identifies who issued the token
		},
	}

	// Create a new token object, specifying the signing method (HS256) and the claims.
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// Sign the token with our secret key to get the complete, signed token string.
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		return "", fmt.Errorf("error signing token: %w", err)
	}

	return tokenString, nil
}

// Parses a JWT string, validates its signature and expiration,
// and returns the UserID from its claims if it is valid.
func ValidateTokenAndGetUserID(tokenString string) (int, error) {
	// Initialize a new instance of our custom claims struct.
	claims := &CustomClaims{}

	// Parse the JWT string. The key function provides the secret key for verification.
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		// Verify the signing method is what we expect (HMAC in this case).
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		// Return the secret key for validation.
		return jwtKey, nil
	})

	if err != nil {
		// This will catch errors like an expired token, malformed token, etc.
		return 0, fmt.Errorf("error parsing token: %w", err)
	}

	// Check if the token is valid and contains our claims.
	// The `token.Valid` check is crucial as it ensures all standard claims passed validation.
	if claims, ok := token.Claims.(*CustomClaims); ok && token.Valid {
		return claims.UserID, nil
	}

	return 0, fmt.Errorf("invalid token")
}
