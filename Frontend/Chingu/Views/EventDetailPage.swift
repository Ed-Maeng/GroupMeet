//
//  EventDetailPage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct EventDetailPage: View {
    let event: Event
    var isJoined: Bool
    var onJoinToggle: () -> Void
    var onAttendeeTapped: (Attendee) -> Void
    var onViewAllAttendeesTapped: () -> Void
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    AsyncImage(url: URL(string: event.imageUrl)) { $0.resizable().aspectRatio(contentMode: .fill) } placeholder: { Rectangle().fill(Color.gray.opacity(0.2)) }
                        .frame(height: 250).clipped()
                    VStack(alignment: .leading, spacing: 16) {
                        Text(event.title).font(.largeTitle).bold()
                        Text(event.description).foregroundColor(.secondary)
                    }.padding(.horizontal)
                    Divider()
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Details").font(.title2).bold()
                        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
                            GridRow { DetailGridItem(title: "Date", value: event.date); DetailGridItem(title: "Time", value: event.time) }
                            GridRow { DetailGridItem(title: "Location", value: event.location); DetailGridItem(title: "Organizer", value: event.organizer) }
                        }
                    }.padding(.horizontal)
                    Rectangle().fill(Color.green.opacity(0.1)).frame(height: 150).overlay(Text("Map Placeholder").foregroundColor(.green)).cornerRadius(12).padding(.horizontal)
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: onViewAllAttendeesTapped) {
                            HStack {
                                Text("Attendees (\(event.attendees.count))").font(.title2).bold()
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }.foregroundColor(.primary)
                        AttendeeIconsView(attendees: event.attendees, onAttendeeTapped: onAttendeeTapped)
                    }.padding(.horizontal)
                    Button(action: { print("Add to Calendar tapped") }) {
                        Label("Add to Calendar", systemImage: "calendar.badge.plus")
                            .fontWeight(.bold).frame(maxWidth: .infinity).padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
                    }.padding(.horizontal)
                    Spacer(minLength: 100)
                }
            }
            HStack {
                Button(action: onJoinToggle) {
                    Text(isJoined ? "You've Joined!" : "Join Event")
                        .fontWeight(.bold).foregroundColor(.white).frame(maxWidth: .infinity).padding()
                        .background(isJoined ? Color.gray : Color.green).cornerRadius(15)
                }
            }.padding().background(.thinMaterial)
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .top) {
            HStack {
                Button(action: { dismiss() }) { Image(systemName: "arrow.left").font(.headline.bold()).foregroundColor(.primary).padding(10).background(.thinMaterial).clipShape(Circle()) }
                Spacer()
                Button(action: {}) { Image(systemName: "square.and.arrow.up").font(.headline.bold()).foregroundColor(.primary).padding(10).background(.thinMaterial).clipShape(Circle()) }
            }.padding()
        }
    }
    
    struct DetailGridItem: View {
        let title: String; let value: String
        var body: some View {
            VStack(alignment: .leading) { Text(title).font(.caption).foregroundColor(.secondary); Text(value).font(.headline).fontWeight(.medium) }
        }
    }
}
