//
//  ChatListPage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct ChatListPage: View {
    // --- NEW ---
    // An action to be called when a chat is tapped
    var onChatSelected: (Chat) -> Void

    let chats = [
        Chat(id: 1, name: "Soccer Match at UCLA", createdAt: "2025-06-25T16:20:23.934652-07:00")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Header(title: "Chats")

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(chats) { chat in
                        // --- CHANGED ---
                        // Wrap the card in a button to make it tappable
                        Button(action: { onChatSelected(chat) }) {
                            ChatCard(chat: chat)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    if chats.isEmpty {
                        Text("No active chats. Join an event to start chatting!")
                            .foregroundColor(.secondary).padding(.top, 40)
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
}
