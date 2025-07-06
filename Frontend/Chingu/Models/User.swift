//
//  User.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct User: Identifiable, Equatable {
    let id: UUID
    let fullName: String
    let university: String
    let email: String
    var profilePhoto: String?
    var friendIDs: [UUID] = []
    var badges: [Badge] = []
}
