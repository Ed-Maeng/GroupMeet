//
//  MyEventManagementCard.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct MyEventManagementCard: View {
    let event: Event
    var onEdit: () -> Void
    var onViewAttendees: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(event.title).font(.headline).bold()
                    Text("\(event.date) • \(event.time)").font(.subheadline).foregroundColor(.secondary)
                }
                Spacer()
                Menu {
                    Button("Edit Event", action: onEdit)
                    Button("View Attendees", action: onViewAttendees)
                    Button("Delete Event", role: .destructive, action: onDelete)
                } label: {
                    Image(systemName: "ellipsis.circle.fill").font(.title2).foregroundColor(.secondary)
                }
            }
            HStack {
                AttendeeIconsView(attendees: event.attendees, onAttendeeTapped: { _ in })
                Spacer()
                Text("\(event.participants)/\(event.totalSlots) Filled").font(.caption.bold()).foregroundColor(.secondary)
            }
        }.padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
    }
}
