# Chingu - Backend

This directory contains the Go-based backend server for the Chingu application. It provides a RESTful API for handling user authentication, event management, and real-time chat.

---

## Setup and Installation

### Prerequisites
- Go (version 1.18 or newer)
- PostgreSQL (version 13 or newer)
- A running PostgreSQL instance

1. Clone the Repository
```bash
git clone https://github.com/Ed-Maeng/Chingu.git
cd /Backend
```

2. Install Dependencies
Install the required Go modules.
```bash
go mod tidy
```

3. Database Setup
You need to create a database in your PostgreSQL instance. Then, you can use the provided `schema.sql` file to set up the necessary tables.
```bash
CREATE DATABASE groupmeet;
\i path/to/your/schema.sql
```

4. Configure Environment Variables
Create a `.env` file in this directory. You can copy the structure from `.env.example` if you have one.

Fill the `.env` file with your specific configuration:
```bash
# Server Configuration
PORT=8080

# Database Connections
DB_HOST=gmt-prod-eus-pgflex.postgres.database.azure.com
DB_PORT=5432
DB_NAME=groupmeet_db
DB_USER=<REPLACE>
DB_PASSWORD=<REPLACE>
DB_AUTH_METHOD=password

# JWT Secret Key (MUST be a long, random string for security)
JWT_KEY=<REPLACE>
```

5. Run the Server
```bash
go run main.go
```

The server will start and listen on the port specified in your .env file (e.g., http://localhost:8080).

---

## API Endpoints
All endpoints are prefixed with `/v1`.

### Authentication
| Method | Endpoint    | Description                             | Protection |
| ------ | ----------- | --------------------------------------- | ---------- |
| POST   | `/register` | Creates a new user and returns a JWT.   | Public     |
| POST   | `/login`    | Authenticates a user and returns a JWT. | Public     |

### Users
| Method | Endpoint    | Description                                      | Protection |
| ------ | ----------- | ------------------------------------------------ | ---------- |
| GET    | `/users/me` | Retrieves the profile of the authenticated user. | Protected  |

### Events
| Method | Endpoint                | Description                               | Protection |
| ------ | ----------------------- | ----------------------------------------- | ---------- |
| POST   | `/events`               | Creates a new event.                      | Protected  |
| GET    | `/events`               | Retrieves a list of all events.           | Protected  |
| GET    | `/events/:eventID`      | Retrieves details for a single event.     | Protected  |
| POST   | `/events/:eventID/join` | Joins the authenticated user to an event. | Protected  |

### Chat
| Method | Endpoint                       | Description                                  | Protection |
| ------ | ------------------------------ | -------------------------------------------- | ---------- |
| GET    | `/chatrooms`                   | Gets all chat rooms the user is a member of. | Protected  |
| GET    | `/chatrooms/:eventID/messages` | Gets all messages for a specific chat room.  | Protected  |
| POST   | `/chatrooms/:eventID/messages` | Posts a new message to a specific chat room. | Protected  |

