//
//  Attendee1.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import Foundation
import SwiftUI

struct Attendee: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let profileImageUrl: String
}
