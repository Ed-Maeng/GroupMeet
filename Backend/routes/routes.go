package routes

import (
	"net/http"

	"groupmeet/controllers"
	"groupmeet/middleware"

	"github.com/gin-gonic/gin"
)

// SetupRoutes configures and returns the main Gin engine with all API routes.
func SetupRoutes() *gin.Engine {
	// Initialize the Gin engine with default middleware (logger and recovery)
	r := gin.Default()

	// --- Public Route Grouping ---
	// Routes that do not require authentication
	public := r.Group("/api/v1")
	{
		// Health Check Endpoint
		public.GET("/health", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{"status": "OK"})
		})

		// Authentication
		public.POST("/register", controllers.CreateUser)
		public.POST("/login", controllers.LoginUser)
	}

	// --- Protected API Route Grouping ---
	// All routes in this group will require authentication
	protected := r.Group("/api/v1")
	protected.Use(middleware.AuthMiddleware())
	{
		// --- User Routes ---
		users := protected.Group("/users")
		{
			users.GET("/:userID", controllers.GetUser)
		}

		// --- Event Routes ---
		events := protected.Group("/events")
		{
			events.POST("/", controllers.CreateEvent)
			events.GET("/", controllers.GetAllEvents)
			events.GET("/:eventID", controllers.GetEvent)
			events.POST("/:eventID/join", controllers.JoinEvent)
		}

		// --- Chat Routes ---
		chatrooms := protected.Group("/chatrooms")
		{
			// Gets a list of all chat rooms the authenticated user is in.
			chatrooms.GET("/", controllers.GetUserChatRooms)

			chats := protected.Group("/chatrooms/:eventID")
			{
				// Gets all messages for a specific chat room.
				chats.GET("/messages", controllers.GetChatRoomMessages)
				// Posts a new message to a specific chat room.
				chats.POST("/messages", controllers.PostChatMessage)
			}
		}
	}

	// Return the configured router
	return r
}
