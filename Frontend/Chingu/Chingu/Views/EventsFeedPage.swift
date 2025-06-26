//
//  EventsFeedPage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct EventsFeedPage: View {
    // ADDED: A closure that this view will call when an event needs to be displayed.
    // This is the "contract" with ContentView.
    var onEventSelected: (Event) -> Void

    // Mock event data
    let events: [Event] = [
        Event(title: "UCLA CS 101 Study Session", date: "Fri, Jul 26", time: "3:00 PM - 5:00 PM", location: "Royce Hall 150", type: "Study Group", participants: 22, maxCapacity: 30, isPopular: true),
        Event(title: "Casual Basketball Pick-up Game", date: "Sat, Jul 27", time: "10:00 AM - 12:00 PM", location: "Wooden Center Courts", type: "Sports", participants: 15, maxCapacity: 20, isPopular: true),
        Event(title: "Board Game Night: Catan & Ticket to Ride", date: "Sat, Jul 27", time: "7:00 PM - 10:00 PM", location: "De Neve Plaza Room", type: "Gaming", participants: 8, maxCapacity: 12, isPopular: false),
        Event(title: "Campus Cleanup Volunteering", date: "Sun, Jul 28", time: "9:00 AM - 1:00 PM", location: "UCLA Botanical Garden", type: "Volunteering", participants: 5, maxCapacity: nil, isPopular: false),
        Event(title: "Intro to React Workshop", date: "Mon, Jul 29", time: "6:00 PM - 8:00 PM", location: "Boelter Hall 420", type: "Creative Workshop", participants: 18, maxCapacity: 25, isPopular: false),
        Event(title: "Yoga & Mindfulness Session", date: "Tue, Jul 30", time: "8:00 AM - 9:00 AM", location: "Sunset Recreation Center Lawn", type: "Fitness", participants: 10, maxCapacity: 15, isPopular: false)
    ]

    @State private var selectedCategory: String? = nil
    @State private var sortOrder: SortOrder = .date

    private var filteredAndSortedEvents: [Event] {
        var filteredEvents = events
        if let category = selectedCategory {
            filteredEvents = events.filter { $0.type == category }
        }
        switch sortOrder {
        case .date:
            filteredEvents.sort { $0.title < $1.title }
        case .popularity:
            filteredEvents.sort { $0.participants > $1.participants }
        case .capacity:
            filteredEvents.sort { ($0.maxCapacity ?? 0) > ($1.maxCapacity ?? 0) }
        }
        return filteredEvents
    }

    var body: some View {
        VStack(spacing: 0) {
            Header(
                title: "Events",
                leftIcon: "magnifyingglass",
                onLeftClick: { print("Search tapped") },
                rightIcons: ["bell.fill", "square.and.arrow.up.fill"],
                onRightClick: { print("Notifications/Share tapped") }
            )

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // ... The Picker and horizontal filter ScrollView remain unchanged ...
                    Picker("Sort By", selection: $sortOrder) {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    Text("Filter by Category")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .padding(.top, 5)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Button("All") {
                                selectedCategory = nil
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == nil ? Color.PrimaryGreen : Color.gray.opacity(0.2))
                            .foregroundColor(selectedCategory == nil ? .white : .primary)
                            .cornerRadius(20)
                            .font(.subheadline)
                            .fontWeight(.medium)

                            ForEach(Array(Set(events.map { $0.type })).sorted(), id: \.self) { category in
                                Button(category) {
                                    selectedCategory = (selectedCategory == category ? nil : category)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedCategory == category ? Color.PrimaryGreen : Color.gray.opacity(0.2))
                                .foregroundColor(selectedCategory == category ? .white : .primary)
                                .cornerRadius(20)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 10)

                VStack(spacing: 15) {
                    if selectedCategory == nil {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("🎉 Trending Events!")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            // CHANGED: This now uses the new TrendingEventCard helper view
                            ForEach(events.filter { $0.isPopular }) { event in
                                TrendingEventCard(event: event, onJoinTapped: {
                                    // The card's action calls the page's action
                                    onEventSelected(event)
                                })
                            }
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color("SecondaryBlueLight"), Color("SecondaryBlueDark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                        .padding([.horizontal, .top])
                    }

                    // CHANGED: This now passes the onJoinTapped action into the EventCard
                    ForEach(filteredAndSortedEvents) { event in
                        EventCard(event: event, onJoinTapped: {
                            // The card's action calls the page's action
                            onEventSelected(event)
                        })
                    }
                    .padding(.horizontal)

                    Button("Load More Events") {
                        print("Load more events tapped")
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("PrimaryGreen"))
                    .padding(.vertical, 10)
                    .padding(.bottom, 20)
                }
                .padding(.top, 5)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        }
    }
}


// --- NEW HELPER VIEW ---
// It's good practice to extract reusable parts like this into their own structs.
struct TrendingEventCard: View {
    let event: Event
    // This allows the card to tell its parent when the button is tapped
    var onJoinTapped: () -> Void
    
    var body: some View {
        // The whole card is a button that performs the passed-in action
        Button(action: onJoinTapped) {
            HStack {
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor.label).opacity(0.8))
                    Text("\(event.date) - \(event.time)")
                        .font(.caption)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
                Spacer()
                Text("Join Now")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding([.vertical, .horizontal], 8)
                    .background(Color("PrimaryGreen"))
                    .cornerRadius(8)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(10)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
