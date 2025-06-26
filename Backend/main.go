package main

import (
	"log"

	"groupmeet/config"
	"groupmeet/database"
	"groupmeet/routes"
)

func main() {
	log.Println("Starting application...")

	cfg, err := config.LoadAppConfig()
	if err != nil {
		log.Fatalf("Error loading App configuration: %v", err)
	}

	// Establish Database Connection
	err = database.Connect()
	if err != nil {
		log.Fatalf("Failed to establish database connection: %v", err)
	}

	defer func() {
		log.Println("Application shutting down. Closing database connection...")
		database.Close()
	}()

	// Set up the Gin Router using your routes package
	router := routes.SetupRoutes()

	log.Printf("Server is starting on http://localhost:%s", cfg.Port)
	if err := router.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}

	log.Println("Application finished its work.")
}
