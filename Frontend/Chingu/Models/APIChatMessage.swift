//
//  APIChatMessage.swift
//  Chingu
//
//  Created by David Kim on 7/2/25. // Adjust date as needed
//

import Foundation

// This struct directly mirrors the data structure from your API response
// for a single message.
struct APIChatMessage: Identifiable, Codable {
    // Maps to `message_id` from your DB
    let id: Int // Renamed from message_id in JSON to 'id' for Identifiable protocol

    // Maps to `event_id` from your DB (though you might not need it for *each* message object
    // if it's implicitly part of the endpoint, good to have for completeness)
    let eventId: Int

    // Maps to `sender_user_id` from your DB
    let senderUserId: Int // Renamed from sender_user_id in JSON to 'senderUserId' for Swift convention

    // Maps to `message_text` from your DB
    let messageText: String // Renamed from message_text in JSON to 'messageText'

    // Maps to `timestamp` from your DB
    let timestamp: String // Assuming API sends as ISO 8601 string, e.g., "2025-07-02T15:30:00Z"

    // If your backend uses snake_case (message_id, sender_user_id, message_text)
    // you'll need a CodingKeys enum to map them to Swift's camelCase properties.
    enum CodingKeys: String, CodingKey {
        case id = "message_id"
        case eventId = "event_id"
        case senderUserId = "sender_user_id"
        case messageText = "message_text"
        case timestamp
    }
}

// Represents the top-level structure of the API response if it's an array wrapped in an object
// For example: `{"messages": [...]}`
struct APIMessagesResponse: Codable {
    let messages: [APIChatMessage]
}
