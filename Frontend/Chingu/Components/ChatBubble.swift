//
//  ChatBubble.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage
    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer() }
            Text(message.text).padding(.horizontal, 16).padding(.vertical, 10)
                .background(message.isFromCurrentUser ? .green : Color(UIColor.systemGray5))
                .foregroundColor(message.isFromCurrentUser ? .white : .primary)
                .cornerRadius(20)
            if !message.isFromCurrentUser { Spacer() }
        }.id(message.id)
    }
}
