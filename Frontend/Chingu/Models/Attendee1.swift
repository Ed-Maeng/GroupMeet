import Foundation
import SwiftUI

struct Attendee: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let profileImageUrl: String
}
