//
//  User.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct User: Identifiable {
    let id = UUID()
    let fullName: String
    let university: String
    let email: String
    var profilePhoto: String? // SF Symbol name or URL
}
