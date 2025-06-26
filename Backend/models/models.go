package models

import "time"

type User struct {
	UserID            int       `db:"user_id" json:"user_id"`
	PreferenceID      int       `db:"preference_id" json:"preference_id"`
	Email             string    `db:"email" json:"email"`
	PasswordHash      string    `db:"password_hash" json:"password"`
	Name              string    `db:"name" json:"name"`
	School            string    `db:"school" json:"school"`
	ProfilePictureURL *string   `db:"profile_picture_url" json:"profile_picture_url"`
	CreatedAt         time.Time `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time `db:"updated_at" json:"updated_at"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type AuthResponse struct {
	Token string `json:"token"`
}

type Preference struct {
	PreferenceID int    `db:"preference_id" json:"preference_id"`
	Type         string `db:"type" json:"type"`
	Name         string `db:"name" json:"name"`
}

type Event struct {
	EventID             int       `db:"event_id" json:"event_id"`
	PreferenceID        int       `db:"preference_id" json:"preference_id"`
	CreatedByUserID     int       `db:"created_by_user_id" json:"created_by_user_id"`
	Name                string    `db:"name" json:"name"`
	Date                time.Time `db:"date" json:"date"`
	Description         *string   `db:"description" json:"description"`
	Location            string    `db:"location" json:"location"`
	CurrentParticipants int       `db:"current_participants" json:"current_participants"`
	MaxUsers            int       `db:"max_users" json:"max_users"`
	CreatedAt           time.Time `db:"created_at" json:"created_at"`
	UpdatedAt           time.Time `db:"updated_at" json:"updated_at"`
}

type EventParticipant struct {
	EventID  int       `db:"event_id" json:"event_id"`
	UserID   int       `db:"user_id" json:"user_id"`
	JoinedAt time.Time `db:"joined_at" json:"joined_at"`
}

type ChatRoom struct {
	EventID   int       `db:"event_id" json:"event_id"`
	Name      string    `db:"name" json:"name"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
}

type ChatMessage struct {
	MessageID    int       `db:"message_id" json:"message_id"`
	EventID      int       `db:"event_id" json:"event_id"`
	SenderUserID int       `db:"sender_user_id" json:"sender_user_id"`
	SenderName   string    `json:"sender_name"`
	MessageText  string    `db:"message_text" json:"message_text"`
	Timestamp    time.Time `db:"timestamp" json:"timestamp"`
}

type PostMessageRequest struct {
	Content string `json:"content" binding:"required,min=1,max=1000"`
}
