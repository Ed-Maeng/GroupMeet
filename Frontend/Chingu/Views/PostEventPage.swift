//
//  PostEventPage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct PostEventPage: View {
    var onSave: (Event) -> Void
    var eventToEdit: Event?
    let currentUser: User

    @State private var title = ""; @State private var description = ""; @State private var eventDate = Date(); @State private var location = ""; @State private var eventType = "Study Group"; @State private var maxParticipants = ""; @State private var visibility = "University Only"
    let eventTypes = ["Study Group", "Sports", "Gaming", "Social", "Volunteering"]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text(eventToEdit == nil ? "New Event" : "Edit Event").font(.headline).bold()
                    Spacer()
                }.padding()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        FormField(label: "TITLE") { TextField("e.g., UCLA CS 32 Study Session", text: $title) }
                        FormField(label: "DESCRIPTION") { TextEditor(text: $description).frame(height: 100) }
                        FormField(label: "DATE & TIME") { DatePicker("Date", selection: $eventDate, displayedComponents: [.date, .hourAndMinute]).labelsHidden() }
                        FormField(label: "LOCATION") { TextField("e.g., Powell Library, Room 220", text: $location) }
                        FormField(label: "EVENT TYPE") { Picker("Event Type", selection: $eventType) { ForEach(eventTypes, id: \.self) { Text($0).tag($0) } }.pickerStyle(.menu) }
                        FormField(label: "MAX PARTICIPANTS") { TextField("Optional", text: $maxParticipants).keyboardType(.numberPad) }
                        FormField(label: "VISIBILITY") { Picker("Visibility", selection: $visibility) { Text("University Only").tag("University Only"); Text("Public").tag("Public") }.pickerStyle(.segmented) }
                    }.padding().padding(.bottom, 100)
                }
            }
            Button(action: handleSave) {
                Text(eventToEdit == nil ? "Publish Event" : "Save Changes")
                    .fontWeight(.bold).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.green).cornerRadius(15)
            }.padding().background(.thinMaterial)
        }
        .onAppear(perform: populateFormForEditing)
    }

    private func populateFormForEditing() {
        if let event = eventToEdit {
            title = event.title
            description = event.description
            location = event.location
        }
    }

    private func handleSave() {
        let savedEvent: Event
        if var event = eventToEdit {
            event.title = title
            event.description = description
            event.location = location
            savedEvent = event
        } else {
            savedEvent = Event(title: title, date: eventDate.formatted(date: .abbreviated, time: .omitted), time: eventDate.formatted(date: .omitted, time: .shortened), location: location, type: eventType, participants: 1, totalSlots: Int(maxParticipants) ?? 0, imageUrl: "https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=60", isPopular: false, organizer: currentUser.fullName, attendees: [], description: description)
        }
        onSave(savedEvent)
    }
}
