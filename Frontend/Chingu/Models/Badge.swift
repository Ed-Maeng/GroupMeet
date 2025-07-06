//
//  Badge.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct Badge: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let iconName: String
    let color: Color
}
