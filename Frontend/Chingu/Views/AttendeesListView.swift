//
//  AttendeesListView.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct AttendeesListView: View {
    let attendees: [Attendee]
    
    var body: some View {
        NavigationView {
            List(attendees) { attendee in
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: attendee.profileImageUrl)) { $0.resizable().aspectRatio(contentMode: .fill) } placeholder: { Color.gray.opacity(0.3) }
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                    Text(attendee.name)
                        .fontWeight(.medium)
                }
            }
            .navigationTitle("Attendees")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
