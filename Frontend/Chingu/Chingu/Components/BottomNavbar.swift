//
//  BottomNavbar.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var currentPage: String

    var body: some View {
        HStack {
            NavBarItem(icon: "house.fill", label: "Home", page: "home", currentPage: $currentPage)
            NavBarItem(icon: "plus.circle.fill", label: "Post", page: "postEvent", currentPage: $currentPage)
            NavBarItem(icon: "message.fill", label: "Chat", page: "chat", currentPage: $currentPage)
            NavBarItem(icon: "person.fill", label: "Profile", page: "profile", currentPage: $currentPage)
        }
        .padding(.vertical, 8) // Padding top/bottom of nav bar items
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(25) // This corner radius is for the actual content view within the main ZStack
        .shadow(radius: 5)
    }
}
