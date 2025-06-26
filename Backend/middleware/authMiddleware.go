package middleware

import (
	"net/http"
	"strings"

	"groupmeet/auth"

	"github.com/gin-gonic/gin"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Get token from "Authorization: Bearer <token>" header
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header is required"})
			c.Abort() // Stop processing the request
			return
		}

		// Validate the header format: "Bearer <token>"
		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header format must be Bearer {token}"})
			c.Abort()
			return
		}
		tokenString := parts[1]

		// Validate the token and extract claims
		userID, err := auth.ValidateTokenAndGetUserID(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		// Attach userID to the context for downstream handlers
		c.Set("userID", userID)

		// Continue to the next handler
		c.Next()
	}
}
