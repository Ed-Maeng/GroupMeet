//
//  ChatCard.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct ChatCard: View {
    let chat: Chat
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.2.circle.fill").resizable().frame(width: 50, height: 50).foregroundColor(.gray.opacity(0.8))
            VStack(alignment: .leading) {
                Text(chat.name).font(.headline).bold()
                Text(chat.lastMessage).font(.subheadline).foregroundColor(.secondary).lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(chat.time).font(.caption).foregroundColor(.secondary)
                if chat.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }.padding(.vertical, 4)
    }
}
