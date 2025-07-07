//
//  NewEventCard.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct NewEventCard: View {
    let event: Event
    var onQuickViewTapped: () -> Void

    private var progress: Double {
        guard event.totalSlots > 0 else { return 0 }
        return Double(event.participants) / Double(event.totalSlots)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(event.date) • \(event.time)").font(.caption).foregroundColor(.secondary)
                    Text(event.title).font(.title3).bold().foregroundColor(.primary)
                    Text(event.location).font(.subheadline).foregroundColor(.secondary)
                    Button(action: onQuickViewTapped) {
                        HStack { Text("Quick View"); Image(systemName: "chevron.right") }
                        .font(.caption.bold()).padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Color(UIColor.systemGray5)).cornerRadius(15)
                    }.padding(.top, 4)
                }
                Spacer()
                AsyncImage(url: URL(string: event.imageUrl)) { $0.resizable().aspectRatio(contentMode: .fill) } placeholder: { Rectangle().fill(Color.gray.opacity(0.2)) }
                .frame(width: 80, height: 80).cornerRadius(12)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("\(event.participants)/\(event.totalSlots) slots filled").font(.caption).foregroundColor(.secondary)
                ProgressView(value: progress).tint(.green)
            }
        }.padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(20)
    }
}
