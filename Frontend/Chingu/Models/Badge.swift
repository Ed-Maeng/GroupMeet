import Foundation
import SwiftUI

struct Badge: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let iconName: String
    let color: Color
}
