//
//  ChatDetailPage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct ChatDetailPage: View {
    let chat: Chat
    @State private var messages = mockChatMessages
    @State private var newMessageText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack(spacing: 16) { ForEach(messages) { ChatBubble(message: $0) } }.padding()
                        .onChange(of: messages.count) { if let lastId = messages.last?.id { proxy.scrollTo(lastId, anchor: .bottom) } }
                    }
                }
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $newMessageText).padding(10).background(Color(UIColor.systemGray5)).cornerRadius(20)
                    Button(action: sendMessage) { Image(systemName: "arrow.up.circle.fill").font(.system(size: 32)).foregroundColor(newMessageText.isEmpty ? .gray : .green) }
                    .disabled(newMessageText.isEmpty)
                }.padding().background(Color(UIColor.secondarySystemGroupedBackground))
            }
            .navigationTitle(chat.name).navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        messages.append(ChatMessage(text: newMessageText, isFromCurrentUser: true))
        newMessageText = ""
    }
}
