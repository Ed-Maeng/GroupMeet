//
//  Interest.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import Foundation

struct Interest: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let iconName: String
}
