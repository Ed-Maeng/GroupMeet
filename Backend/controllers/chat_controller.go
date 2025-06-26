package controllers

import (
	"log"
	"net/http"
	"strconv"
	"time"

	"groupmeet/database"
	"groupmeet/models"

	"github.com/gin-gonic/gin"
)

// Helper function to check if a given user is a participant of a given event.
// This is a crucial authorization check for all chat functionality to ensure privacy.
func isUserParticipant(c *gin.Context, userID int, eventID int) (bool, error) {
	var exists bool
	// This query efficiently checks for the existence of a record without retrieving any data.
	query := `SELECT EXISTS(SELECT 1 FROM event_participants WHERE user_id = $1 AND event_id = $2)`
	err := database.Conn.QueryRow(c.Request.Context(), query, userID, eventID).Scan(&exists)
	if err != nil {
		// Log the internal database error.
		log.Printf("Database error in isUserParticipant check for user %d, event %d: %v", userID, eventID, err)
		return false, err
	}
	return exists, nil
}

// TODO: Let's fetch from chatrooms table
// Handles fetching all chat rooms (events) that the currently authenticated user is a participant of.
func GetUserChatRooms(c *gin.Context) {
	// Get the authenticated user's ID from the context
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		log.Println("Critical error: userID not found in context.")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not process user identity"})
		return
	}
	userID := userIDFromToken.(int)

	log.Printf("Endpoint Hit: GetUserChatRooms for user ID %d", userID)

	// This query joins the events and event_participants tables to find all events
	// that the currently authenticated user has joined, returning them as chatrooms.
	query := `
        SELECT e.event_id, e.name, e.created_at
        FROM events e
        JOIN eventparticipants ep ON e.event_id = ep.event_id
        WHERE ep.user_id = $1
        ORDER BY e.created_at DESC
    `
	rows, err := database.Conn.Query(c.Request.Context(), query, userID)
	if err != nil {
		log.Printf("Database error fetching chat rooms for user %d: %v", userID, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch chatrooms"})
		return
	}
	defer rows.Close()

	// Iterate over the query results and build a slice of ChatRoom models.
	var chatRooms []models.ChatRoom
	for rows.Next() {
		var room models.ChatRoom
		if err := rows.Scan(&room.EventID, &room.Name, &room.CreatedAt); err != nil {
			log.Printf("Error scanning chat room row: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process chat room data"})
			return
		}
		chatRooms = append(chatRooms, room)
	}

	// Check for any errors encountered during row iteration.
	if err = rows.Err(); err != nil {
		log.Printf("Error iterating chat room rows: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process chat rooms"})
		return
	}

	// To ensure a consistent JSON response, return an empty list `[]` instead of `null` if no rooms are found.
	if chatRooms == nil {
		chatRooms = make([]models.ChatRoom, 0)
	}

	c.JSON(http.StatusOK, chatRooms)
}

// GetChatRoomMessages handles fetching all messages for a specific chat room (event).
func GetChatRoomMessages(c *gin.Context) {
	// Extract eventID from the URL parameter.
	eventIDStr := c.Param("eventID")
	eventID, err := strconv.Atoi(eventIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid event ID format"})
		return
	}

	// Get the authenticated user's ID from the context
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		log.Println("Critical error: userID not found in context.")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not process user identity"})
		return
	}
	userID := userIDFromToken.(int)

	log.Printf("Endpoint Hit: GetChatRoomMessages for event ID %d by user ID %d", eventID, userID)

	// Authorization check: User must be a participant to read messages.
	isParticipant, err := isUserParticipant(c, userID, eventID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "A server error occurred while checking authorization"})
		return
	}
	if !isParticipant {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not authorized to view this chat"})
		return
	}

	// Fetch messages and join with the users table to get the sender's name for a richer response.
	query := `
        SELECT cm.message_id, cm.event_id, cm.sender_user_id, u.name, cm.message_text, cm.timestamp
        FROM chat_messages cm
        JOIN users u ON cm.sender_user_id = u.user_id
        WHERE cm.event_id = $1
        ORDER BY cm.timestamp ASC
    `
	rows, err := database.Conn.Query(c.Request.Context(), query, eventID)
	if err != nil {
		log.Printf("Database error fetching messages for event %d: %v", eventID, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch messages"})
		return
	}
	defer rows.Close()

	var messages []models.ChatMessage
	for rows.Next() {
		var msg models.ChatMessage
		if err := rows.Scan(
			&msg.MessageID, &msg.EventID, &msg.SenderUserID, &msg.SenderName, &msg.MessageText, &msg.Timestamp,
		); err != nil {
			log.Printf("Error scanning message row: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process message data"})
			return
		}
		messages = append(messages, msg)
	}

	if messages == nil {
		messages = make([]models.ChatMessage, 0)
	}

	c.JSON(http.StatusOK, messages)
}

// PostChatMessage handles posting a new message to a specific chat room.
func PostChatMessage(c *gin.Context) {
	// Extract IDs and perform authorization.
	eventIDStr := c.Param("eventID")
	eventID, err := strconv.Atoi(eventIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid event ID format"})
		return
	}

	// Get the authenticated user's ID from the context
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		log.Println("Critical error: userID not found in context.")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not process user identity"})
		return
	}
	userID := userIDFromToken.(int)

	log.Printf("Endpoint Hit: PostChatMessage for event ID %d by user ID %d", eventID, userID)

	// Authorization check: User must be a participant to post messages.
	isParticipant, err := isUserParticipant(c, userID, eventID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "A server error occurred while checking authorization"})
		return
	}
	if !isParticipant {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not authorized to post in this chat"})
		return
	}

	// Decode the request body.
	var req models.PostMessageRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload. 'content' field is required."})
		return
	}

	// Insert the new message and return the full message object, including the sender's name.
	// A Common Table Expression (CTE) is used to first insert the data, then join it with the users table.
	var createdMsg models.ChatMessage
	query := `
        WITH inserted_msg AS (
            INSERT INTO chat_messages (event_id, sender_user_id, message_text, timestamp)
            VALUES ($1, $2, $3, $4)
            RETURNING message_id, event_id, sender_user_id, message_text, timestamp
        )
        SELECT im.message_id, im.event_id, im.sender_user_id, u.name, im.message_text, im.timestamp
        FROM inserted_msg im
        JOIN users u ON im.sender_user_id = u.user_id
    `
	err = database.Conn.QueryRow(c.Request.Context(), query,
		eventID, userID, req.Content, time.Now().UTC(),
	).Scan(
		&createdMsg.MessageID, &createdMsg.EventID, &createdMsg.SenderUserID,
		&createdMsg.SenderName, &createdMsg.MessageText, &createdMsg.Timestamp,
	)
	if err != nil {
		log.Printf("Database error creating chat message for event %d: %v", eventID, err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to post message"})
		return
	}

	log.Printf("User %d successfully posted message %d to event %d", userID, createdMsg.MessageID, eventID)
	c.JSON(http.StatusCreated, createdMsg)
}
