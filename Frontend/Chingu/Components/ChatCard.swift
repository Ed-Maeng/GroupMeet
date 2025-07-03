//
//  ChatCard.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct ChatCard: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: 15) {
            
            // --- TEMPORARY TEST CODE ---
            // This version uses system colors to make sure the view appears.
            ZStack {
                Circle()
                    // Using a standard system color
                    .fill(Color.blue.opacity(0.2))

                Text(chat.name.prefix(2).uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    // Using a standard system color
                    .foregroundColor(.blue)
            }
            .frame(width: 55, height: 55)
            // --- END OF TEST CODE ---

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text("TEMP-Last Message Show up Here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(chat.createdAt)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

// The preview remains the same
struct ChatCard_Previews: PreviewProvider {
    static var previews: some View {
        ChatCard(
            chat: Chat(id: 1, name: "Soccer Match at UCLA", createdAt: "2025-06-25T16:20:23.934652-07:00")
        )
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}
