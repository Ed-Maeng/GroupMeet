//
//  Chat1.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//
import Foundation
import SwiftUI

struct Chat: Identifiable, Equatable {
    let id: UUID
    let name: String
    var lastMessage: String
    var time: String
    var isPinned: Bool = false
}
