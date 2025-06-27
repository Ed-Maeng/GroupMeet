//
//  EventCard.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct EventCard: View {
    let event: Event
    
    // ADDED: A closure property to be called when the button is tapped.
    var onJoinTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // This top part remains the same...
            Text(event.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            HStack(spacing: 5) {
                Image(systemName: "calendar")
                    .foregroundColor(Color("PrimaryGreen"))
                Text("\(event.date), \(event.time)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 5) {
                Image(systemName: "location.fill")
                    .foregroundColor(Color("PrimaryGreen"))
                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                Text(event.type)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("SecondaryBlue").opacity(0.2))
                    .cornerRadius(20)
                    .foregroundColor(Color("SecondaryBlueDark"))

                Spacer()

                Text("\(event.participants) \(event.maxCapacity.map { "/ \($0)" } ?? "+") Participants")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // --- CHANGED: This is now a real button again ---
            // Its action calls the onJoinTapped closure that was passed in.
            Button(action: onJoinTapped) {
                Text("Join Event")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color("PrimaryGreen"))
                    .cornerRadius(10)
                    .shadow(color: Color("PrimaryGreen").opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
