//
//  EventDetialPage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

//
//  EventDetailPage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct EventDetailPage: View {
    // The event to display, passed from the previous screen.
    let event: Event
    
    // An action to close this detail view.
    var onDismiss: () -> Void
    
    @State private var hasJoined = false

    var body: some View {
        VStack(spacing: 0) {
            // We can reuse our Header component!
            Header(
                title: "Event Details",
                leftIcon: "xmark",
                onLeftClick: onDismiss // Use the dismiss action
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // --- EVENT TITLE ---
                    Text(event.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    // --- DATE & TIME ---
                    HStack(spacing: 15) {
                        Image(systemName: "calendar.circle.fill")
                            .font(.title2)
                            .foregroundColor(.PrimaryGreen)
                        VStack(alignment: .leading) {
                            Text(event.date).fontWeight(.medium)
                            Text(event.time).foregroundColor(.secondary)
                        }
                    }

                    // --- LOCATION ---
                    HStack(spacing: 15) {
                        Image(systemName: "location.circle.fill")
                            .font(.title2)
                            .foregroundColor(.PrimaryGreen)
                        Text(event.location)
                            .fontWeight(.medium)
                    }

                    // --- PARTICIPANTS ---
                    HStack(spacing: 15) {
                        Image(systemName: "person.2.circle.fill")
                            .font(.title2)
                            .foregroundColor(.PrimaryGreen)
                        Text("\(event.participants) \(event.maxCapacity.map { "/ \($0)" } ?? "+") Participants")
                            .fontWeight(.medium)
                    }
                    
                    Divider()

                    // --- DESCRIPTION ---
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About this event")
                            .font(.headline)
                        Text("This is a placeholder description for the event. In a real app, this would contain more details about what to expect, what to bring, and any other relevant information for attendees. For now, enjoy this lovely placeholder text!")
                            .foregroundColor(.secondary)
                            .lineSpacing(5)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
            // --- JOIN BUTTON (at the bottom) ---
            Button(action: {
                // Toggle the joined state with an animation
                withAnimation {
                    hasJoined.toggle()
                }
                print("Join button tapped for \(event.title)")
            }) {
                HStack {
                    Image(systemName: hasJoined ? "checkmark.circle.fill" : "person.crop.circle.badge.plus")
                    Text(hasJoined ? "You've Joined!" : "Join Event")
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(hasJoined ? Color.blue : Color.PrimaryGreen) // Change color on join
                .cornerRadius(15)
                .shadow(color: (hasJoined ? Color.blue : Color.PrimaryGreen).opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}
