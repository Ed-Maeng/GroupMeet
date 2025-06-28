//
//  TrendingEventCard.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct TrendingEventCard: View {
    let event: Event
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: event.imageUrl)) { $0.resizable().aspectRatio(contentMode: .fill) } placeholder: { Rectangle().fill(Color.gray.opacity(0.3)) }
            LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8)]), startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading) {
                Text(event.title).font(.headline).fontWeight(.bold).foregroundColor(.white)
                Text(event.location).font(.subheadline).foregroundColor(.white.opacity(0.8))
            }.padding()
        }.frame(width: 260, height: 150).cornerRadius(20).shadow(radius: 5)
    }
}
