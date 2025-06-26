package controllers

import (
	"context"
	"errors"
	"log"
	"net/http"
	"strconv"
	"time"

	"groupmeet/auth"
	"groupmeet/database"
	"groupmeet/models"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgconn"
	"golang.org/x/crypto/bcrypt"
)

// Handles the registration of a new user.
func CreateUser(c *gin.Context) {
	log.Println("Endpoint Hit: CreateUser")

	// Decode request body into User struct
	var req models.User
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("Error decoding request body: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	// Hash the password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.PasswordHash), bcrypt.DefaultCost)
	if err != nil {
		log.Printf("Error hashing password: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error processing password"})
		return
	}

	// Insert user into the database
	query := `
		INSERT INTO users (preference_id, name, school, email, password_hash, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
		RETURNING user_id
	`
	err = database.Conn.QueryRow(c.Request.Context(), query,
		req.PreferenceID,
		req.Name,
		req.School,
		req.Email,
		string(hashedPassword),
		time.Now().UTC(),
		time.Now().UTC(),
	).Scan(&req.UserID)

	if err != nil {
		// Check for specific, known errors like a unique constraint violation.
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) && pgErr.Code == "23505" {
			log.Printf("Conflict: User already exists %d.", req.UserID)
			c.JSON(http.StatusConflict, gin.H{"error": "Your email already exists"})
			return
		}

		// For all other errors, return a generic 500.
		log.Printf("Error inserting user into database: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "A server error occurred while trying to create a user"})
		return
	}

	log.Printf("Successfully created event with ID: %d", req.UserID)

	// Generate and return a JWT. This provides a seamless register-and-login flow.
	tokenString, err := auth.GenerateToken(req.UserID)
	if err != nil {
		log.Printf("Successfully created user but failed to generate token: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "User created, but failed to log in. Please try logging in manually."})
		return
	}

	c.JSON(http.StatusCreated, models.AuthResponse{Token: tokenString})
}

// Handles fetching a single user by their ID.
func GetUser(c *gin.Context) {
	userIDStr := c.Param("userID")
	log.Printf("Endpoint Hit: GetUser with ID: %s", userIDStr)

	// Convert userID to integer
	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		log.Printf("Invalid user ID: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	// Query the database for the user
	query := `
		SELECT user_id, preference_id, email, name, school, created_at, updated_at
		FROM users
		WHERE user_id = $1
	`
	var user models.User
	err = database.Conn.QueryRow(context.Background(), query, userID).Scan(
		&user.UserID,
		&user.PreferenceID,
		&user.Email,
		&user.Name,
		&user.School,
		&user.CreatedAt,
		&user.UpdatedAt,
	)

	if err != nil {
		if err.Error() == "no rows in result set" {
			log.Printf("User not found with ID: %d", userID)
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		} else {
			log.Printf("Database error: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		}
		return
	}

	log.Printf("Successfully retrieved user with ID: %d", userID)
	c.JSON(http.StatusOK, user)
}

// Handles user authentication and returns a JWT upon success.
func LoginUser(c *gin.Context) {
	log.Println("Endpoint Hit: LoginUser")

	// Decode request body into LoginRequest struct
	var req models.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("Error decoding request body: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	// Fetch the user from the database by email
	var user models.User
	query := `SELECT user_id, password_hash FROM users WHERE email = $1`
	err := database.Conn.QueryRow(c.Request.Context(), query, req.Email).Scan(&user.UserID, &user.PasswordHash)
	if err != nil {
		// If no user is found, or any other DB error occurs, return unauthorized.
		// We use a generic message to avoid confirming whether an email exists.
		log.Printf("Authentication failed for email %s: %v", req.Email, err)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	// Compare the provided password with the stored hash
	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password))
	if err != nil {
		// If passwords don't match, return unauthorized.
		log.Printf("Password mismatch for user ID %d", user.UserID)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	// If credentials are correct, generate a JWT
	tokenString, err := auth.GenerateToken(user.UserID)
	if err != nil {
		log.Printf("Error generating JWT for user ID %d: %v", user.UserID, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not generate token"})
		return
	}

	// Send the token back to the client
	log.Printf("Successfully authenticated user ID %d", user.UserID)
	c.JSON(http.StatusOK, models.AuthResponse{Token: tokenString})
}
