//
//  SortOrder.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import Foundation

// This enum defines the different ways a user can sort the event list.
// By placing it in its own file, it's accessible to the entire app.
enum SortOrder: String, CaseIterable {
    case date = "By Date"
    case popularity = "By Popularity"
    case capacity = "By Capacity"
}
