//
//  Header.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct Header: View {
    let title: String
    var leftIcon: String? = nil // SF Symbol name
    var onLeftClick: (() -> Void)? = nil
    var rightIcons: [String]? = nil // Array of SF Symbol names
    var onRightClick: (() -> Void)? = nil

    var body: some View {
        HStack {
            if let leftIcon = leftIcon {
                Button(action: onLeftClick ?? {}) {
                    Image(systemName: leftIcon)
                        .font(.title2)
                        .padding(8)
                        .background(Color("PrimaryGreen").opacity(0.1))
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Spacer().frame(width: 44) // Placeholder for alignment
            }

            Spacer()

            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            if let rightIcons = rightIcons, !rightIcons.isEmpty {
                HStack(spacing: 8) {
                    ForEach(rightIcons, id: \.self) { iconName in
                        Button(action: onRightClick ?? {}) {
                            Image(systemName: iconName)
                                .font(.title2)
                                .padding(8)
                                .background(Color("PrimaryGreen").opacity(0.1))
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            } else {
                Spacer().frame(width: 44) // Placeholder for alignment
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("PrimaryGreen"))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
