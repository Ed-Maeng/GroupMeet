# GroupMeet

GroupMeet is an IOS application designed to help people discover and join local events based on shared interests and preferences. It provides a platform for event creation, participation, and real-time communication among attendees.

---

## Features

- **User Authentication**: Secure user registration and login using JWT (JSON Web Tokens).
- **Event Management**: Users can create, browse, and view details of events.
- **Event Participation**: Users can join and leave events, with participant counts updated in real-time.
- **Real-time Chat**: Every event has a dedicated chat room accessible only to its participants.
- **Profile Management**: Users can view their own profile information.

---

## Tech Stack

- **Frontend**: Swift
- **Backend**: Go, Gin, PostgreSQL
- **Cloud**: Azure

---

## Project Structure

The project is organized into two main directories:

- `/Backend`: Contains the Go-based REST API server.
- `/Frontend`: (Placeholder for the client-side application).

Each directory has its own specific `README.md` with detailed setup and usage instructions.

---

## Getting Started

To get the full application running, you will need to start both the backend and frontend services.

### 1. Frontend Setup

Navigate to the backend directory and follow the instructions in `Frontend/README.md`.

```bash
cd Frontend/
# Follow the setup instructions in Frontend/README.md
swift main.swift
```

### 2. Backend Setup

Navigate to the backend directory and follow the instructions in `Backend/README.md`.

```bash
cd Backend/
# Follow the setup instructions in Backend/README.md
go run main.go
```
