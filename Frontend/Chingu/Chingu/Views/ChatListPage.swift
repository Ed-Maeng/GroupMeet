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
        Chat(name: "UCLA CS 101 Study Group", lastMessage: "Don't forget the midterm is next week!", time: "2h ago"),
        Chat(name: "Basketball Pick-up", lastMessage: "Who's playing tomorrow?", time: "Yesterday"),
        Chat(name: "Board Game Night", lastMessage: "Anyone bringing new games?", time: "3 days ago"),
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
