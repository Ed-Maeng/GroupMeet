//
//  ChatDetailPage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct ChatDetailPage: View {
    // The chat info passed from the previous screen
    let chat: Chat
    var onDismiss: () -> Void
    
    // --- Mock Data & State for the Front-End ---
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hey everyone! Glad we could connect here before the study session.", isFromCurrentUser: false),
        ChatMessage(text: "Me too! Does anyone know if we should bring our textbooks?", isFromCurrentUser: true),
        ChatMessage(text: "The professor said it's optional but recommended.", isFromCurrentUser: false),
        ChatMessage(text: "Awesome, thanks!", isFromCurrentUser: true)
    ]
    
    @State private var newMessageText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            Header(
                title: chat.name,
                leftIcon: "xmark",
                onLeftClick: onDismiss
            )
            
            // --- Message List ---
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                    .onChange(of: messages.count) {
                        if let lastMessage = messages.last {
                            withAnimation {
                                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            // --- Text Input Bar ---
            HStack(spacing: 12) {
                TextField("Type a message...", text: $newMessageText)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(newMessageText.isEmpty ? .gray : .PrimaryGreen)
                }
                .disabled(newMessageText.isEmpty)
            }
            .padding()
            .background(Color(UIColor.systemBackground))
        }
        .background(Color(UIColor.secondarySystemGroupedBackground).ignoresSafeArea())
    }
    
    func sendMessage() {
        guard !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Add the new message to our local array
        messages.append(ChatMessage(text: newMessageText, isFromCurrentUser: true))
        
        // Clear the text field
        newMessageText = ""
    }
}

// A helper view for the chat bubble UI
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer() // Push sent messages to the right
            }
            
            Text(message.text)
                .padding()
                .background(message.isFromCurrentUser ? Color.PrimaryGreen : Color(UIColor.systemGray4))
                .foregroundColor(message.isFromCurrentUser ? .white : .primary)
                .cornerRadius(20)
            
            if !message.isFromCurrentUser {
                Spacer() // Push received messages to the left
            }
        }
        .id(message.id) // Add an ID for the auto-scrolling
    }
}
