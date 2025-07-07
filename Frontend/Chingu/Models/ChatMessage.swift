//
//  ChatMessage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//
import Foundation
import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isFromCurrentUser: Bool
}
