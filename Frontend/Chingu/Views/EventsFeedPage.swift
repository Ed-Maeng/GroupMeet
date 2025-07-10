//
//  EventsFeedPage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct EventsFeedPage: View {
    var onEventSelected: (Event) -> Void
    let schoolName: String
    @Binding var selectedTab: ContentView.Tab
    @Binding var events: [Event]
    @State private var selectedCategory: String = "All"
    let categories = ["All", "Study", "Sports", "Social", "Volunteering"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) { trendingSection; allEventsSection }.padding(.vertical)
            }
            .navigationTitle(schoolName)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { selectedTab = .profile }) {
                        Image(systemName: "person.crop.circle.fill").font(.title2).foregroundColor(.primary)
                    }
                }
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading) {
            Text("Trending").font(.title2).bold().padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(events.filter { $0.isPopular }) { event in TrendingEventCard(event: event).onTapGesture { onEventSelected(event) } }
                }.padding(.horizontal)
            }
        }
    }

    private var allEventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("All Events").font(.title2).bold().padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            Text(category).font(.subheadline).bold().padding(.horizontal, 16).padding(.vertical, 8)
                                .background(selectedCategory == category ? Color.primary : Color(UIColor.systemGray5))
                                .foregroundColor(selectedCategory == category ? Color(UIColor.systemBackground) : Color.primary)
                                .cornerRadius(20)
                        }
                    }
                }.padding(.horizontal)
            }
            LazyVStack(spacing: 16) {
                ForEach(events) { event in
                    NewEventCard(event: event, onQuickViewTapped: {
                        onEventSelected(event)
                    })
                }
            }.padding(.horizontal)
        }
    }
}
