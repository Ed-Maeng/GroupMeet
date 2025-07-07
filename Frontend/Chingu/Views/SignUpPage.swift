//
//  SignUpPage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct SignUpPage: View {
    var onSignUp: (User) -> Void
    var onNavigateToSignIn: () -> Void
    @State private var fullName = ""; @State private var university = "UCLA"; @State private var email = ""; @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack { Text("Create Account").font(.largeTitle).bold(); Text("Join the Chingu community today!").foregroundColor(.secondary) }
            VStack(spacing: 16) {
                TextField("Full Name", text: $fullName).padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
                TextField("Email Address", text: $email).padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12).keyboardType(.emailAddress).autocapitalization(.none)
                SecureField("Password", text: $password).padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
                Menu {
                    ForEach(universities) { uni in Button(uni.name) { university = uni.name } }
                } label: {
                    HStack {
                        Text("University"); Spacer(); Text(university).foregroundColor(.secondary)
                        Image(systemName: "chevron.up.chevron.down").font(.caption.bold()).foregroundColor(.secondary)
                    }.padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12).foregroundColor(.primary)
                }
            }
            Button(action: handleSignUp) { Text("Create Account").fontWeight(.bold).foregroundColor(.white).frame(height: 50).frame(maxWidth: .infinity).background(Color.green).cornerRadius(12) }
            Spacer()
            HStack { Text("Already have an account?"); Button("Log In") { onNavigateToSignIn() }.fontWeight(.bold).foregroundColor(.green) }
        }.padding()
    }
    
    private func handleSignUp() {
        onSignUp(User(id: UUID(), fullName: fullName, university: university, email: email, profilePhoto: "", badges: mockBadges))
    }
}
