import SwiftUI

@main
struct ChinguApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

let mockAttendees: [Attendee] = [
    .init(name: "Jessica", profileImageUrl: "https://randomuser.me/api/portraits/women/1.jpg"),
    .init(name: "Mark", profileImageUrl: "https://randomuser.me/api/portraits/men/2.jpg"),
    .init(name: "Sarah", profileImageUrl: "https://randomuser.me/api/portraits/women/3.jpg"),
    .init(name: "James", profileImageUrl: "https://randomuser.me/api/portraits/men/4.jpg"),
    .init(name: "Emily", profileImageUrl: "https://randomuser.me/api/portraits/women/5.jpg"),
    .init(name: "Chris", profileImageUrl: "https://randomuser.me/api/portraits/men/6.jpg")
]

let initialMockEvents: [Event] = [
  Event(title: "Outdoor Movie Night", date: "Fri, Apr 12", time: "7:00 PM", location: "Campus Green", type: "Social", participants: 12, totalSlots: 20, imageUrl: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60", isPopular: true, organizer: "Chingu", attendees: Array(mockAttendees.prefix(12)), description: "Join us for a cozy movie night under the stars! We'll be showing a classic film. Bring your own blankets and snacks!"),
  Event(title: "UCLA CS 101 Study Session", date: "Sat, Apr 13", time: "3:00 PM", location: "Royce Hall 150", type: "Study", participants: 22, totalSlots: 30, imageUrl: "https://images.unsplash.com/photo-1521737711867-e3b97375f902?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60", isPopular: true, organizer: "CS Club", attendees: Array(mockAttendees.prefix(4)), description: "Midterm coming up! Let's review the key concepts together and solve some practice problems. All are welcome."),
  Event(title: "Casual Basketball Pick-up", date: "Sat, Apr 13", time: "10:00 AM", location: "Wooden Center Courts", type: "Sports", participants: 15, totalSlots: 20, imageUrl: "https://images.unsplash.com/photo-1546519638-68e109498ffc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60", isPopular: false, organizer: "David Kim", attendees: Array(mockAttendees.prefix(6)), description: "Just a friendly game of 5-on-5. Come shoot some hoops and have fun!"),
]

let initialMockChats: [Chat] = [
  Chat(id: initialMockEvents[1].id, name: "UCLA CS 101 Study Session", lastMessage: "Don't forget the midterm is next week!", time: "2h ago"),
  Chat(id: initialMockEvents[2].id, name: "Basketball Pick-up", lastMessage: "Who's playing tomorrow?", time: "Yesterday"),
]

let mockChatMessages: [ChatMessage] = [
    ChatMessage(text: "Hey everyone! Glad we could connect here.", isFromCurrentUser: false),
    ChatMessage(text: "Me too! Should we bring textbooks?", isFromCurrentUser: true),
]

let universities: [University] = [
    .init(name: "UCLA", logoName: "building.columns.fill"),
    .init(name: "USC", logoName: "building.columns.fill"),
    .init(name: "UCSD", logoName: "building.columns.fill"),
    .init(name: "Stanford", logoName: "building.columns.fill"),
    .init(name: "Berkeley", logoName: "building.columns.fill"),
    .init(name: "Caltech", logoName: "building.columns.fill"),
]

let interests: [Interest] = [
    .init(name: "Sports", iconName: "sportscourt.fill"),
    .init(name: "Music", iconName: "music.mic"),
    .init(name: "Gaming", iconName: "gamecontroller.fill"),
    .init(name: "Art", iconName: "paintpalette.fill"),
    .init(name: "Tech", iconName: "laptopcomputer"),
    .init(name: "Movies", iconName: "film.fill"),
    .init(name: "Food", iconName: "fork.knife"),
    .init(name: "Volunteering", iconName: "heart.fill")
]

let mockBadges: [Badge] = [
    .init(name: "First Event", iconName: "sparkles", color: .yellow),
    .init(name: "Social Butterfly", iconName: "figure.2.and.child.holdinghands", color: .pink),
    .init(name: "Organizer", iconName: "crown.fill", color: .purple)
]
