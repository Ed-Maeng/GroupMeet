# Chingu

Chingu is an iOS application designed to help university students discover, create, and join local campus events. It provides a platform for event creation, participation, and communication among attendees, with the goal of fostering a vibrant and connected campus community.

---

## Features

- **Event Discovery**: Browse a dynamic feed of campus events, with filtering by category and sorting by date, popularity, or capacity.
- **User-Created Events**: A dedicated form allows any user to create and post their own events to the community.
- **Event Details & Participation**: View a detailed page for each event and a 'Join' button to show intent.
- **Mock Chat System**: A complete UI for both a list of active chats and a detailed, real-time-like conversation screen with styled message bubbles.
- **User Authentication UI**: Front-end flow for user sign-up and login, featuring an animated success confirmation.
- **Modern UI/UX**: Includes an animated splash screen, full Dark Mode support, and fluid, responsive animations for page transitions.

---

## Tech Stack

- **Platform**: iOS
- **Language**: Swift
- **UI Framework**: SwiftUI
- **IDE**: Xcode

---

## Project Structure

The Xcode project is organized logically into groups based on component function to ensure code clarity and maintainability:

- `App`: Contains the main application entry point and lifecycle management.
- `Views`: Major, full-screen views that represent the different pages of the app (e.g., `EventsFeedPage`, `ChatDetailPage`).
- `Components`: Smaller, reusable UI pieces that are used across multiple views (e.g., `EventCard`, `Header`).
- `Models`: The data structures that define the shape of the app's data (e.g., `Event`, `User`, `Chat`).
- `Extensions`: Swift extensions that add custom functionality to existing types, such as custom colors.

---

## Getting Started

This project is a self-contained front-end prototype that can be run directly in the Xcode simulator.

### Prerequisites
- A Mac computer with macOS (Ventura 13.0 or newer recommended).
- Xcode (version 15.0 or newer recommended).

### Running the Application

1.  **Clone the Repository**
    ```bash
    git clone <your-repository-url>
    cd Chingu
    ```

2.  **Open in Xcode**
    Navigate to the cloned project folder and double-click the **`Chingu.xcodeproj`** file to open it.

3.  **Build and Run**
    Once the project is open, select an iOS Simulator from the target menu (e.g., "iPhone 15 Pro") and press the **Run** button (or `Cmd + R`).

---

## Future Development

This prototype serves as the complete visual and interactive foundation for the app. The next phase of development would focus on building and integrating a backend service to:

- **Implement a real REST API** to handle live data for users, events, and messages.
- **Add a database** (e.g., PostgreSQL, MongoDB) for persistent data storage.
- **Enable a real-time chat service** using WebSockets or a service like Firebase.
- **Connect the front-end app** to this backend to replace the current mock data with live data.
