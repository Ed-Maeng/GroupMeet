//
//  PublicProfileView.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct PublicProfileView: View {
    let attendee: Attendee
    @Binding var currentUser: User
    @Environment(\.dismiss) var dismiss
    
    var isFriend: Bool {
        currentUser.friendIDs.contains(attendee.id)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: attendee.profileImageUrl)) { $0.resizable().aspectRatio(contentMode: .fill) } placeholder: { Color.gray.opacity(0.3) }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            
            Text(attendee.name).font(.largeTitle).bold()
            Text("UCLA").font(.headline).foregroundColor(.secondary) // Placeholder
            
            Button(action: {
                if !isFriend {
                    currentUser.friendIDs.append(attendee.id)
                }
            }) {
                Label(isFriend ? "Friends" : "Add Friend", systemImage: isFriend ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.plus")
                    .fontWeight(.bold).padding().frame(maxWidth: .infinity)
                    .background(isFriend ? Color.gray : Color.green).foregroundColor(.white).cornerRadius(12)
            }
            .disabled(isFriend)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .overlay(alignment: .topLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark").font(.headline.bold()).foregroundColor(.secondary)
                    .padding(10).background(.thinMaterial).clipShape(Circle())
            }.padding()
        }
    }
}
