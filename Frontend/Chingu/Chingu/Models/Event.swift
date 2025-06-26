//
//  Event.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import Foundation

// CHANGED: Added Equatable so SwiftUI can compare two Event objects.
struct Event: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let date: String
    let time: String
    let location: String
    let type: String
    let participants: Int
    let maxCapacity: Int?
    let isPopular: Bool
}
