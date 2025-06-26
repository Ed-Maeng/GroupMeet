//
//  ProfilePage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct ProfilePage: View {
    let user: User?

    var body: some View {
        VStack(spacing: 0) {
            Header(title: "Profile")

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color("SecondaryBlue").opacity(0.2))
                    
                    // --- THIS IS THE CORRECTED SECTION ---
                    if let user = user {
                        let firstTwo = user.fullName.prefix(2).uppercased()
                        Text(firstTwo)
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(Color("SecondaryBlueDark"))
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color("SecondaryBlueDark"))
                    }
                    // --- END OF CORRECTION ---

                }
                .frame(width: 120, height: 120)
                .overlay(Circle().stroke(Color("PrimaryGreen").opacity(0.4), lineWidth: 3))
                .shadow(radius: 5)
                .padding(.bottom, 10)

                Text(user?.fullName ?? "John Doe")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(user?.university ?? "UCLA")
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(user?.email ?? "john.doe@ucla.edu")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                VStack(spacing: 10) { // Spacing for buttons
                    ProfileActionButton(title: "Account Settings", icon: "gearshape.fill", action: { print("Account Settings tapped") })
                    ProfileActionButton(title: "Privacy Policy", icon: "hand.raised.fill", action: { print("Privacy Policy tapped") })
                    ProfileActionButton(title: "Help & Support", icon: "questionmark.circle.fill", action: { print("Help & Support tapped") })
                    
                    Button(action: { print("Log Out tapped") }) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .foregroundColor(.red)
                            Text("Log Out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures content is centered vertically
            .background(Color.white.ignoresSafeArea())
        }
    }
}
