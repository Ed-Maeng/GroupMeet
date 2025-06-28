//
//  AttendeeIconsView.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct AttendeeIconsView: View {
    let attendees: [Attendee]
    var onAttendeeTapped: (Attendee) -> Void
    
    let maxVisible: Int = 5
    var body: some View {
        HStack(spacing: -12) {
            ForEach(Array(attendees.prefix(maxVisible).enumerated()), id: \.element.id) { index, attendee in
                Button(action: { onAttendeeTapped(attendee) }) {
                    AsyncImage(url: URL(string: attendee.profileImageUrl)) { $0.resizable().aspectRatio(contentMode: .fill) } placeholder: { Color.gray.opacity(0.3) }
                    .frame(width: 36, height: 36).clipShape(Circle())
                    .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 2))
                    .zIndex(Double(attendees.count - index))
                }
            }
            if attendees.count > maxVisible {
                Text("+\(attendees.count - maxVisible)").font(.caption.bold()).foregroundColor(.secondary)
                    .frame(width: 36, height: 36).background(Color(UIColor.systemGray5)).clipShape(Circle())
                    .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 2))
            }
        }
    }
}
