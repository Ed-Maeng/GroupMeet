//
//  ContentView.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct ContentView: View {
    // MARK: - State Properties
    
    // Controls the main page displayed (signIn, home, chat, etc.)
    @State private var currentPage: String = "signIn"
    
    // Holds the user data after a successful sign-in
    @State private var user: User? = nil
    
    // Holds the event the user tapped on to show the detail page
    @State private var selectedEvent: Event? = nil
    
    // Holds the chat the user tapped on to show the detail page
    @State private var selectedChat: Chat? = nil

    // MARK: - Body
    
    var body: some View {
        ZStack {
            // The main view of the app (either sign-in or the tab view)
            mainAppView
            
            // --- Overlays for Detail Pages ---
            
            // If an event is selected, slide the EventDetailPage up from the bottom
            if let event = selectedEvent {
                EventDetailPage(event: event, onDismiss: {
                    // This closure is called by the detail page's back button
                    selectedEvent = nil
                })
                .transition(.move(edge: .bottom))
            }
            
            // If a chat is selected, slide the ChatDetailPage up from the bottom
            if let chat = selectedChat {
                ChatDetailPage(chat: chat, onDismiss: {
                    // This closure is called by the detail page's back button
                    selectedChat = nil
                })
                .transition(.move(edge: .bottom))
            }
        }
        // Animate the presentation of the detail pages
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedEvent)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: selectedChat)
    }
    
    // MARK: - Main App View Builder
    
    // This computed property builds the primary view based on the current page state.
    @ViewBuilder
    private var mainAppView: some View {
        // If the user is not signed in, show the sign-in page
        if currentPage == "signIn" {
            SignInPage(onSignInSuccess: { userData in
                self.user = userData
                // Animate the transition to the home page
                withAnimation {
                    self.currentPage = "home"
                }
            })
        } else {
            // If the user is signed in, show the main app with the tab bar
            ZStack(alignment: .bottom) {
                Group {
                    if currentPage == "home" {
                        EventsFeedPage(onEventSelected: { event in
                            self.selectedEvent = event
                        })
                    } else if currentPage == "postEvent" {
                        PostEventPage(onCancel: { self.currentPage = "home" }, onPostSuccess: { self.currentPage = "home" })
                    } else if currentPage == "chat" {
                        ChatListPage(onChatSelected: { chat in
                            self.selectedChat = chat
                        })
                    } else if currentPage == "profile" {
                        ProfilePage(user: user)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // The bottom navigation bar
                BottomNavBar(currentPage: $currentPage)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
