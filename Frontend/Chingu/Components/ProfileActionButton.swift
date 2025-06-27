//
//  ProfileActionButton.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct ProfileActionButton: View {
    let title: String
    let icon: String // SF Symbol name
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color("PrimaryGreen"))
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.gray.opacity(0.08)) // Light gray background
            .cornerRadius(12)
        }
    }
}
