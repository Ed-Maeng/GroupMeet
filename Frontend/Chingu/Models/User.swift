import Foundation
import SwiftUI

// Request body for user
struct User: Identifiable, Codable, Equatable {
    let id: Int
    let preferenceID: Int
    let email: String
    let name: String
    let school: String
    let profilePictureURL: String?
    var friendIDs: [UUID] = []
    var badges: [Badge] = []

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case preferenceID = "preference_id"
        case email
        case name
        case school
        case profilePictureURL = "profile_picture_url"
    }
}

// Request body for login
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// Request body for sign up
struct SignUpRequest: Codable {
    let preferenceID: Int
    let email: String
    let password: String
    let name: String
    let school: String
    // let profilePictureURL: String?
    
    enum CodingKeys: String, CodingKey {
        case preferenceID = "preference_id"
        case email
        case password
        case name
        case school
        // case profilePictureURL = "profile_picture_url"
    }
}
