import Foundation
import SwiftUI

struct AuthResponse: Decodable {
    let token: String
    let expiresIn: Int
}
