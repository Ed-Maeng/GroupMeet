//
//  ChatDetailPage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

// MARK: - Networking Service

class ChatService: ObservableObject {
    @Published var messages: [APIChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let authToken: String
    // IMPORTANT: currentUserID is now Int, matching sender_user_id
    let currentUserID: Int // This should come from your authentication system

    init(authToken: String, currentUserID: Int) {
        self.authToken = authToken
        self.currentUserID = currentUserID
    }

    // Helper function to create a URLRequest with the Authorization header
    private func createAuthenticatedRequest(url: URL, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }

    func fetchMessages(forEventId eventId: Int) { // eventId is now Int
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "http://192.168.0.171:8080/api/v1/chatrooms/\(eventId)/messages") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        let request = createAuthenticatedRequest(url: url, httpMethod: "GET")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                        self.errorMessage = "Server error: \(httpResponse.statusCode). Please check token or permissions."
                        print("HTTP Response Error: \(httpResponse.statusCode), URL: \(url)")
                        return
                    }
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    // Attempt to decode as a direct array of APIChatMessage first
                    let decodedMessages = try JSONDecoder().decode([APIChatMessage].self, from: data)
                    self.messages = decodedMessages
                } catch {
                    // If that fails, try decoding with a response wrapper (e.g., {"messages": [...]})
                    do {
                        let response = try JSONDecoder().decode(APIMessagesResponse.self, from: data)
                        self.messages = response.messages
                    } catch {
                        self.errorMessage = "Failed to decode messages: \(error.localizedDescription)"
                        print("Decoding Error: \(error)") // For debugging
                    }
                }
            }
        }.resume()
    }

    func sendMessage(eventId: Int, messageText: String) { // eventId is now Int
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        guard let url = URL(string: "http://192.168.0.171:8080/api/v1/chatrooms/\(eventId)/messages") else {
            self.errorMessage = "Invalid URL for sending message"
            return
        }

        var request = createAuthenticatedRequest(url: url, httpMethod: "POST")

        // Prepare the message payload for the POST request
        // Ensure these keys match what your backend expects for message creation
        let newMessagePayload: [String: Any] = [
            "event_id": eventId, // Pass event_id in payload if backend expects it
            "sender_user_id": currentUserID,
            "message_text": messageText,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: newMessagePayload) else {
            self.errorMessage = "Failed to serialize message data"
            return
        }
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Failed to send message: \(error.localizedDescription)"
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        // Successfully sent.
                        // Ideally, the backend would return the *persisted* message object
                        // including its assigned message_id. For now, we'll optimistically
                        // create one with a dummy ID (0 or some negative number) if the API
                        // doesn't return the full object.
                        // If your API returns the full APIChatMessage object upon success,
                        // you should decode it here and append that.
                        if let data = data, let sentApiMessage = try? JSONDecoder().decode(APIChatMessage.self, from: data) {
                             self.messages.append(sentApiMessage)
                        } else {
                            // Fallback if API doesn't return the full message on POST success
                            // You might need to refetch all messages here, or add a placeholder.
                            // Adding a placeholder requires a unique ID.
                            let tempMessageId = (self.messages.map { $0.id }.max() ?? 0) + 1 // Simple temp ID
                            let sentMessage = APIChatMessage(
                                id: tempMessageId,
                                eventId: eventId,
                                senderUserId: self.currentUserID,
                                messageText: messageText,
                                timestamp: ISO8601DateFormatter().string(from: Date())
                            )
                            self.messages.append(sentMessage)
                        }

                        // IMPORTANT: After sending, it's often a good idea to re-fetch all messages
                        // to ensure the local list is fully synchronized with the server,
                        // especially if the server assigns message_id or changes timestamps.
                        // self.fetchMessages(forEventId: eventId)
                    } else {
                        self.errorMessage = "Failed to send message: Server responded with status \(httpResponse.statusCode)"
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Send Message Error Response: \(responseString)")
                        }
                    }
                } else {
                    self.errorMessage = "Failed to send message: No HTTP response"
                }
            }
        }.resume()
    }
}

// MARK: - ChatDetailPage View

struct ChatDetailPage: View {
    let chat: Chat // This 'chat' likely represents an event or chatroom.
                   // Ensure its 'id' property matches 'event_id' (int4).
    var onDismiss: () -> Void

    let authToken: String
    let currentUserID: Int // currentUserID is now Int

    @StateObject private var chatService: ChatService

    @State private var newMessageText: String = ""

    init(chat: Chat, onDismiss: @escaping () -> Void, authToken: String, currentUserID: Int) {
        self.chat = chat
        self.onDismiss = onDismiss
        self.authToken = authToken
        self.currentUserID = currentUserID
        // Initialize ChatService with the provided token and user ID
        _chatService = StateObject(wrappedValue: ChatService(authToken: authToken, currentUserID: currentUserID))
    }

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
                        if chatService.isLoading {
                            ProgressView("Loading messages...")
                        } else if let errorMessage = chatService.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                        } else if chatService.messages.isEmpty {
                            Text("No messages yet. Start the conversation!")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            // Loop through APIChatMessage and convert to ChatMessage for ChatBubble
                            ForEach(chatService.messages) { apiMessage in
                                let chatMessage = ChatMessage(apiMessage: apiMessage, currentUserID: chatService.currentUserID)
                                ChatBubble(message: chatMessage)
                            }
                        }
                    }
                    .padding()
                    .onChange(of: chatService.messages.count) { _ in
                        // Auto-scroll to the bottom when a new message is added
                        if let lastMessage = chatService.messages.last {
                            withAnimation {
                                // Scroll to the ID of the last API message, which is an Int now
                                scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    // Initial scroll to bottom when view appears and messages are loaded
                    .onAppear {
                        // This might run before messages are loaded, so also use onChange
                        // for when the data actually arrives.
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
        .onAppear {
            // Fetch messages when the view appears.
            // Ensure chat.id is an Int (the event_id).
            // If chat.id is a UUID, you'll need to adjust your 'Chat' model or pass an Int.
            // Assuming chat.id is already Int for the event_id
            chatService.fetchMessages(forEventId: chat.id)
        }
    }

    func sendMessage() {
        guard !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        // Call the service to send the message
        // Ensure chat.id is an Int (the event_id).
        chatService.sendMessage(eventId: chat.id, messageText: newMessageText)

        // Clear the text field
        newMessageText = ""
    }
}

// MARK: - Existing Helper Views (No Changes Needed Here)

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
        .id(message.id) // Add an ID for the auto-scrolling (now an Int)
    }
}
