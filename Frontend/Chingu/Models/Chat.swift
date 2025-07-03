//
//  Chat.swift
//  Chingu
//
//  Created by David Kim on 7/2/25. // Adjust date as needed
//

import Foundation

// This struct represents a single chatroom or event, corresponding to your 'events' table.
// It will be used to pass the context of the selected chatroom to ChatDetailPage.
struct Chat: Identifiable, Codable, Equatable{
    // Maps to `event_id` from your DB, used as the Identifiable 'id'
    let id: Int // Renamed from event_id in JSON to 'id' for Identifiable protocol

    // Maps to `name` from your DB
    let name: String

    // Maps to `created_at` from your DB
    let createdAt: String // Assuming API sends as ISO 8601 string

    // If your backend uses snake_case (event_id, created_at) in the JSON response
    // for this Chat/Event model, you'll need a CodingKeys enum to map them
    // to Swift's camelCase properties.
    enum CodingKeys: String, CodingKey {
        case id = "event_id"
        case name
        case createdAt = "created_at"
    }
}
