//
//  ChatListPage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct ChatListPage: View {
    var onChatSelected: (Chat) -> Void
    @Binding var chats: [Chat]
    
    var sortedChats: [Chat] {
        chats.sorted { $0.isPinned && !$1.isPinned }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedChats) { chat in
                    Button(action: { onChatSelected(chat) }) {
                        ChatCard(chat: chat)
                    }
                    .contextMenu {
                        Button(action: {
                            togglePin(for: chat)
                        }) {
                            Label(chat.isPinned ? "Unpin" : "Pin", systemImage: chat.isPinned ? "pin.slash.fill" : "pin.fill")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Chats")
        }
    }
    
    private func togglePin(for chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].isPinned.toggle()
        }
    }
}
