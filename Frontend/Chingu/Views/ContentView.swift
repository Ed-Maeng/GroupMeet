//
//  ContentView.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI
struct ContentView: View {
    enum AuthScreen { case signIn, signUp }
    enum AppState { case splash, auth, onboarding, loading, main }
    enum Tab { case events, myEvents, post, chats, profile }
    
    enum SheetType: Identifiable {
        case eventDetail(Event)
        case chatDetail(Chat)
        case eventEdit(Event)
        case eventAttendees(Event)
        case publicProfile(Attendee)
        
        var id: String {
            switch self {
            case .eventDetail(let event): return "event-\(event.id)"
            case .chatDetail(let chat): return "chat-\(chat.id)"
            case .eventEdit(let event): return "edit-\(event.id)"
            case .eventAttendees(let event): return "attendees-\(event.id)"
            case .publicProfile(let attendee): return "profile-\(attendee.id)"
            }
        }
    }

    @State private var appState: AppState = .splash
    @State private var authScreen: AuthScreen = .signIn
    @State private var user: User? = nil
    
    @State private var events: [Event] = initialMockEvents
    @State private var chats: [Chat] = initialMockChats
    @State private var joinedEventIDs: Set<UUID> = {
        var ids: Set<UUID> = []
        initialMockChats.forEach { chat in
            if let event = initialMockEvents.first(where: { $0.id == chat.id }) {
                ids.insert(event.id)
            }
        }
        return ids
    }()
    
    @State private var selectedTab: Tab = .events
    @State private var activeSheet: SheetType?

    var body: some View {
        ZStack {
            switch appState {
            case .splash:
                SplashScreenView()
            case .auth:
                authFlow
            case .onboarding:
                ProfileSetupView(onComplete: {
                    withAnimation { appState = .loading }
                })
            case .loading:
                RegistrationAnimationView(onComplete: {
                    withAnimation { appState = .main }
                })
            case .main:
                if let currentUser = user {
                    mainTabView(user: currentUser)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation { appState = .auth }
            }
        }
        .sheet(item: $activeSheet) { sheetType in
            switch sheetType {
            case .eventDetail(let event):
                EventDetailPage(
                    event: event,
                    isJoined: joinedEventIDs.contains(event.id),
                    onJoinToggle: { toggleEventJoinedState(for: event) },
                    onAttendeeTapped: { attendee in activeSheet = .publicProfile(attendee) },
                    onViewAllAttendeesTapped: { activeSheet = .eventAttendees(event) }
                )
            case .chatDetail(let chat):
                ChatDetailPage(chat: chat)
            case .eventEdit(let event):
                PostEventPage(onSave: { updatedEvent in
                    if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
                        events[index] = updatedEvent
                    }
                    activeSheet = nil
                }, eventToEdit: event, currentUser: user!)
            case .eventAttendees(let event):
                AttendeesListView(attendees: event.attendees)
            case .publicProfile(let attendee):
                if user != nil {
                    PublicProfileView(attendee: attendee, currentUser: $user.toBinding())
                }
            }
        }
        .animation(.spring(), value: user)
        .animation(.easeInOut, value: appState)
    }
    
    private func toggleEventJoinedState(for event: Event) {
        if joinedEventIDs.contains(event.id) {
            joinedEventIDs.remove(event.id)
            updateParticipantCount(for: event.id, by: -1)
            chats.removeAll { $0.id == event.id }
        } else {
            joinedEventIDs.insert(event.id)
            updateParticipantCount(for: event.id, by: 1)
            
            if !chats.contains(where: { $0.id == event.id }) {
                let newChat = Chat(id: event.id, name: event.title, lastMessage: "You have joined the event chat!", time: "Now")
                chats.append(newChat)
            }
        }
    }

    private func updateParticipantCount(for eventID: UUID, by amount: Int) {
        if let index = events.firstIndex(where: { $0.id == eventID }) {
            events[index].participants += amount
        }
    }
    
    @ViewBuilder
    private var authFlow: some View {
        switch authScreen {
        case .signIn:
            SignInPage(
                onSignIn: { signedInUser in
                    self.user = signedInUser
                    withAnimation { appState = .main }
                },
                onNavigateToSignUp: { withAnimation(.easeInOut) { self.authScreen = .signUp } }
            )
        case .signUp:
            SignUpPage(
                onSignUp: { signedUpUser in
                    self.user = signedUpUser
                    withAnimation { appState = .onboarding }
                },
                onNavigateToSignIn: { withAnimation(.easeInOut) { self.authScreen = .signIn } }
            )
        }
    }
    
    @ViewBuilder
    func mainTabView(user: User) -> some View {
        VStack(spacing: 0) {
            ZStack {
                Group {
                    EventsFeedPage(onEventSelected: { event in activeSheet = .eventDetail(event) }, universityName: user.university, selectedTab: $selectedTab, events: $events).opacity(selectedTab == .events ? 1 : 0)
                    MyEventsPage(user: user, events: $events, onEditEvent: { event in
                        activeSheet = .eventEdit(event)
                    }, onViewAttendees: { event in
                        activeSheet = .eventAttendees(event)
                    }).opacity(selectedTab == .myEvents ? 1 : 0)
                    PostEventPage(onSave: { newEvent in
                        events.insert(newEvent, at: 0)
                        let newChat = Chat(id: newEvent.id, name: newEvent.title, lastMessage: "Your event chat is ready!", time: "Now")
                        chats.append(newChat)
                        joinedEventIDs.insert(newEvent.id)
                        withAnimation { selectedTab = .events }
                    }, currentUser: user).opacity(selectedTab == .post ? 1 : 0)
                    ChatListPage(onChatSelected: { chat in activeSheet = .chatDetail(chat) }, chats: $chats).opacity(selectedTab == .chats ? 1 : 0)
                    ProfilePage(user: $user.toBinding(), onLogOut: { withAnimation(.spring()) { self.user = nil; self.appState = .auth } }).opacity(selectedTab == .profile ? 1 : 0)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack {
                TabBarButton(icon: "house.fill", label: "Events", tab: .events, selectedTab: $selectedTab)
                TabBarButton(icon: "calendar.badge.plus", label: "My Events", tab: .myEvents, selectedTab: $selectedTab)
                TabBarButton(icon: "plus.circle.fill", label: "Post", tab: .post, selectedTab: $selectedTab)
                TabBarButton(icon: "message.fill", label: "Chats", tab: .chats, selectedTab: $selectedTab)
                TabBarButton(icon: "person.fill", label: "Profile", tab: .profile, selectedTab: $selectedTab)
            }.padding(.horizontal).padding(.top, 10).background(.thinMaterial)
        }.animation(.easeInOut(duration: 0.2), value: selectedTab)
    }
    
    struct TabBarButton: View {
        let icon: String; let label: String; let tab: Tab
        @Binding var selectedTab: Tab
        
        var body: some View {
            Button(action: { selectedTab = tab }) {
                VStack(spacing: 4) {
                    Image(systemName: icon).font(.title2)
                    Text(label).font(.caption)
                }.foregroundColor(selectedTab == tab ? .green : .secondary).frame(maxWidth: .infinity)
            }
        }
    }
}

