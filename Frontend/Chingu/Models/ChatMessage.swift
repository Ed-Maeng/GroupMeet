//
//  ChatMessage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    
    // This is crucial for styling our chat bubbles
    let isFromCurrentUser: Bool
}
