package controllers

import (
	"context"
	"errors"
	"log"
	"net/http"
	"strconv"
	"time"

	"groupmeet/database"
	"groupmeet/models"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgconn"
)

// Handles creating a new event.
func CreateEvent(c *gin.Context) {
	log.Println("Endpoint Hit: CreateEvent")

	// Get the authenticated user's ID from the context
	userIDFromToken, exists := c.Get("userID")
	if !exists {
		log.Println("Critical error: userID not found in context.")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not process user identity"})
		return
	}
	userID := userIDFromToken.(int)

	// Decode request body into Event struct
	var req models.Event
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("Error decoding request body: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	// Insert event into the database
	query := `
        INSERT INTO events (preference_id, created_by_user_id, name, date, description, location, current_participants, max_users, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        RETURNING event_id
    `
	err := database.Conn.QueryRow(c.Request.Context(), query,
		req.PreferenceID,
		userID,
		req.Name,
		req.Date,
		req.Description,
		req.Location,
		1,
		req.MaxUsers,
		time.Now().UTC(),
		time.Now().UTC(),
	).Scan(&req.EventID)

	if err != nil {
		log.Printf("Error inserting event into database: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error creating event"})
		return
	}

	log.Printf("Successfully created event with ID: %d", req.EventID)
	c.JSON(http.StatusCreated, req)
}

// Handles fetching all events, possibly with filters.
func GetAllEvents(c *gin.Context) {
	log.Println("Endpoint Hit: GetAllEvents")

	query := `
		SELECT event_id, preference_id, created_by_user_id, name, date, description, location, current_participants, max_users, created_at, updated_at
		FROM events ORDER BY date DESC
	`
	rows, err := database.Conn.Query(context.Background(), query)
	if err != nil {
		log.Printf("Error fetching events from database: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch events"})
		return
	}
	defer rows.Close()

	var events []models.Event
	for rows.Next() {
		var event models.Event
		if err := rows.Scan(
			&event.EventID,
			&event.PreferenceID,
			&event.CreatedByUserID,
			&event.Name,
			&event.Date,
			&event.Description,
			&event.Location,
			&event.CurrentParticipants,
			&event.MaxUsers,
			&event.CreatedAt,
			&event.UpdatedAt,
		); err != nil {
			log.Printf("Error scanning event row: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process event data"})
			return
		}
		events = append(events, event)
	}

	// Check for errors from iterating over rows.
	if err = rows.Err(); err != nil {
		log.Printf("Error iterating event rows: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process events"})
		return
	}

	// If no events are found, return an empty list, not an error.
	if events == nil {
		events = make([]models.Event, 0)
	}

	// TODO: Create chatroom assoicated with the created event

	log.Printf("Successfully retrieved %d events", len(events))
	c.JSON(http.StatusOK, events)
}

// Handles fetching a single event by its ID.
func GetEvent(c *gin.Context) {
	eventIDStr := c.Param("eventID")
	log.Printf("Endpoint Hit: GetEvent with ID: %s", eventIDStr)

	// Convert eventID from string to integer
	eventID, err := strconv.Atoi(eventIDStr)
	if err != nil {
		log.Printf("Error converting eventID '%s' to int: %v", eventIDStr, err)
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid event ID format"})
		return
	}

	// Query the database for the event
	query := `
		SELECT event_id, preference_id, created_by_user_id, name, date, description, location, current_participants, max_users, created_at, updated_at
		FROM events 
		WHERE event_id=$1
	`
	var event models.Event
	err = database.Conn.QueryRow(context.Background(), query, eventID).Scan(
		&event.EventID,
		&event.PreferenceID,
		&event.CreatedByUserID,
		&event.Name,
		&event.Date,
		&event.Description,
		&event.Location,
		&event.CurrentParticipants,
		&event.MaxUsers,
		&event.CreatedAt,
		&event.UpdatedAt,
	)

	if err != nil {
		if err.Error() == "no rows in result set" {
			log.Printf("User not found with ID: %d", eventID)
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		} else {
			log.Printf("Database error: %v", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		}
		return
	}

	log.Printf("Successfully retrieved event with ID: %d", eventID)
	c.JSON(http.StatusOK, event)
}

// Handles user joining an event
func JoinEvent(c *gin.Context) {
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

	log.Printf("Endpoint Hit: User %d joining Event %d", userID, eventID)

	// The query now correctly inserts into the `event_participants` table.
	query := `
        INSERT INTO eventparticipants (event_id, user_id, joined_at)
        VALUES ($1, $2, $3)
    `
	_, err = database.Conn.Exec(c.Request.Context(), query,
		eventID,
		userID,
		time.Now().UTC(),
	)

	if err != nil {
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) && pgErr.Code == "23505" { // unique_violation
			log.Printf("Conflict: User %d already joined event %d.", userID, eventID)
			c.JSON(http.StatusConflict, gin.H{"error": "You have already joined this event"})
			return
		}
		// You might also get a foreign key violation (23503) if the eventID doesn't exist.
		if errors.As(err, &pgErr) && pgErr.Code == "23503" {
			log.Printf("Foreign key violation: User %d tried to join non-existent event %d.", userID, eventID)
			c.JSON(http.StatusNotFound, gin.H{"error": "This event does not exist."})
			return
		}

		log.Printf("Error inserting event participant into database: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "A server error occurred while trying to join the event"})
		return
	}

	// TODO: You should also increment the `current_participants` count in the `events` table in a transaction.
	// This is a separate step that would be needed for a fully featured implementation.

	log.Printf("Successfully joined event for user with ID: Event - %d and User - %d", eventID, userID)
	c.JSON(http.StatusCreated, gin.H{"message": "Successfully joined event"})
}
