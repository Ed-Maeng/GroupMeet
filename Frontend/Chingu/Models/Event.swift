//
//  Event.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct Event: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var date: String
    var time: String
    var location: String
    var type: String
    var participants: Int
    var totalSlots: Int
    var imageUrl: String
    var isPopular: Bool
    var organizer: String
    var attendees: [Attendee]
    var description: String
}
