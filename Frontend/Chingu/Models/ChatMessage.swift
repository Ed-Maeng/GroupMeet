//
//  ChatMessage.swift
//  Chingu
//
//  Created by David Kim on 7/2/25. // Adjust date as needed
//

import Foundation

// This is your application's internal ChatMessage model,
// optimized for SwiftUI views.
struct ChatMessage: Identifiable {
    // For SwiftUI's Identifiable, we use the backend's message_id (Int)
    let id: Int

    let text: String
    let isFromCurrentUser: Bool
    // You could add other properties here if needed for UI,
    // e.g., senderName: String, timestamp: Date

    // Initializer for mock data or direct creation
    // (Note: For mock data, you'd need to provide a unique 'id' if you keep this init)
    init(id: Int, text: String, isFromCurrentUser: Bool) {
        self.id = id
        self.text = text
        self.isFromCurrentUser = isFromCurrentUser
    }

    // Initializer to convert from APIChatMessage
    // This is the primary way ChatMessage objects will be created from API data.
    init(apiMessage: APIChatMessage, currentUserID: Int) { // currentUserID is now Int
        self.id = apiMessage.id
        self.text = apiMessage.messageText
        self.isFromCurrentUser = (apiMessage.senderUserId == currentUserID)
    }
}
