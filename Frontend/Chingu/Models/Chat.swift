//
//  Chat.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import Foundation

// This struct defines the data model for a single chat conversation preview.
// It needs to be Identifiable to be used in a list, and Equatable for animations.
struct Chat: Identifiable, Equatable {
    // A unique ID for each chat room, required by Identifiable.
    let id = UUID()
    
    // The name of the chat group or person.
    let name: String
    
    // The last message sent in the chat, for the preview.
    let lastMessage: String
    
    // A string representing when the last message was sent.
    let time: String
}
