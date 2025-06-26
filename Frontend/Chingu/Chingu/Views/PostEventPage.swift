//
//  PostEventPage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct PostEventPage: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var location: String = ""
    @State private var eventType: String = "Study Group"
    @State private var maxParticipants: String = ""
    @State private var visibility: String = "university" // 'public' or 'university'

    var onCancel: () -> Void
    var onPostSuccess: () -> Void

    let eventTypes = [
        "Study Group", "Sports", "Gaming", "Volunteering", "Creative Workshop",
        "Social Mixer", "Fitness", "Movie Night", "Cultural Event"
    ]

    var body: some View {
        VStack(spacing: 0) {
            Header(
                title: "New Event",
                leftIcon: "xmark", // Close icon
                onLeftClick: onCancel,
                rightIcons: ["paperplane.fill"], // Post icon
                onRightClick: handlePost
            )

            Form {
                Section {
                    TextField("Title", text: $title, prompt: Text("e.g., UCLA CS 32 Study Session"))
                } header: {
                    Text("Title")
                }
                
                Section {
                    TextEditor(text: $description)
                        .frame(minHeight: 80, maxHeight: 150)
                } header: {
                    Text("Description")
                }

                Section {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                } header: {
                    Text("Date & Time")
                }

                Section {
                    TextField("Location", text: $location, prompt: Text("e.g., Powell Library, Room 220"))
                } header: {
                    Text("Location")
                }

                Section {
                    Picker("Event Type", selection: $eventType) {
                        ForEach(eventTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(.menu) // Modern menu picker
                } header: {
                    Text("Event Type")
                }

                Section {
                    TextField("Max Participants (Optional)", text: $maxParticipants)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Max Participants")
                }

                Section {
                    Picker("Visibility", selection: $visibility) {
                        Text("University Only").tag("university")
                        Text("Public").tag("public")
                    }
                    .pickerStyle(.segmented) // iOS segmented control
                } header: {
                    Text("Visibility")
                }
                
                Button(action: handlePost) {
                    Text("Create Event")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryGreen"))
                        .cornerRadius(10)
                        .shadow(color: Color("PrimaryGreen").opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear) // Remove default list row background
            }
            .scrollContentBackground(.hidden) // Make form background transparent to use overall background
            .background(Color.white.ignoresSafeArea()) // Ensure form area is white
        }
    }
    
    private func handlePost() {
        if !title.isEmpty && !description.isEmpty && !location.isEmpty {
            // In a real app, send data to backend
            print("Event posted: \(title)")
            onPostSuccess()
        } else {
            // In a real app, use an alert or toast
            print("Please fill in all required fields.")
        }
    }
}
