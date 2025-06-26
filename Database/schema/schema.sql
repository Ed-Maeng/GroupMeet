-- Connect to your desired database first.
-- If you need to create a new database, you can use:
-- CREATE DATABASE groupmeet_db;
-- Then connect to it

-- Table: Users
CREATE TABLE Users (
  user_id SERIAL PRIMARY KEY,
  preference_id INT NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  school VARCHAR(255) NOT NULL,
  profile_picture_url VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: Preferences
CREATE TABLE Preferences (
  preference_id SERIAL PRIMARY KEY,
  type VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL UNIQUE
);

-- Table: Events
CREATE TABLE Events (
  event_id SERIAL PRIMARY KEY,
  preference_id INT NOT NULL,
  created_by_user_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  description VARCHAR(255),
  location VARCHAR(255),
  current_participants INT DEFAULT 0,
  max_users INT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_preference
    FOREIGN KEY (preference_id)
    REFERENCES Preferences(preference_id),
  CONSTRAINT fk_created_by_user
    FOREIGN KEY (created_by_user_id)
    REFERENCES Users(user_id)
);

-- Table: EventParticipants
CREATE TABLE EventParticipants (
  event_id INT NOT NULL,
  user_id INT NOT NULL,
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (event_id, user_id),
  CONSTRAINT fk_event
    FOREIGN KEY (event_id)
    REFERENCES Events(event_id)
    ON DELETE CASCADE, -- If an event is deleted, participation records are also deleted
  CONSTRAINT fk_user
    FOREIGN KEY (user_id)
    REFERENCES Users(user_id)
    ON DELETE CASCADE -- If a user is deleted, their participation records are also deleted
);

-- Table: ChatRooms
CREATE TABLE ChatRooms (
  event_id INT PRIMARY KEY, -- Ensures one chatroom per event
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_event_chatroom
    FOREIGN KEY (event_id)
    REFERENCES Events(event_id)
    ON DELETE CASCADE -- If the event is deleted, its chatroom is also deleted
);

-- Table: ChatMessages
CREATE TABLE ChatMessages (
  message_id SERIAL PRIMARY KEY,
  event_id INT NOT NULL,
  sender_user_id INT NOT NULL,
  message_text TEXT NOT NULL,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT fk_chat_room
    FOREIGN KEY (event_id)
    REFERENCES ChatRooms(event_id)
    ON DELETE CASCADE, -- If the chatroom (event) is deleted, messages are also deleted
  CONSTRAINT fk_sender_user
    FOREIGN KEY (sender_user_id)
    REFERENCES Users(user_id)
);

-- Optional: Add indexes for performance on frequently queried columns
CREATE INDEX idx_events_date ON Events (date);
CREATE INDEX idx_eventparticipants_user_id ON EventParticipants (user_id);
CREATE INDEX idx_chatmessages_event_id ON ChatMessages (event_id);
CREATE INDEX idx_chatmessages_sender_user_id ON ChatMessages (sender_user_id);