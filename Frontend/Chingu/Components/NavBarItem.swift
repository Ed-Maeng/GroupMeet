//
//  NavBarItem.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct NavBarItem: View {
    let icon: String
    let label: String
    let page: String
    @Binding var currentPage: String

    var body: some View {
        Button(action: {
            currentPage = page
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(currentPage == page ? Color("PrimaryGreen") : .gray)
            .padding(.vertical, 8)
            .padding(.horizontal, 15) // Increased horizontal padding for tap area
            .background(currentPage == page ? Color("PrimaryGreen").opacity(0.1) : Color.clear)
            .cornerRadius(15) // Rounded background when selected
        }
    }
}
