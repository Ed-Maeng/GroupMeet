//
//  SignInPage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct SignInPage: View {
    var onSignIn: (User) -> Void
    var onNavigateToSignUp: () -> Void
    @State private var email = ""
    @State private var password = ""
    @State private var authState: AuthState = .idle
    enum AuthState { case idle, authenticating, success }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack { Text("Welcome Back!").font(.largeTitle).bold(); Text("Log in to continue your journey.").foregroundColor(.secondary) }.opacity(authState == .idle ? 1 : 0)
            VStack(spacing: 16) {
                TextField("Email Address", text: $email).padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12).keyboardType(.emailAddress).autocapitalization(.none)
                SecureField("Password", text: $password).padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
            }.opacity(authState == .idle ? 1 : 0)
            Button(action: handleSignIn) {
                ZStack {
                    switch authState {
                    case .idle: Text("Log In").fontWeight(.bold)
                    case .authenticating: ProgressView()
                    case .success: Image(systemName: "checkmark").font(.headline.bold())
                    }
                }
                .foregroundColor(.white).frame(height: 50).frame(maxWidth: authState == .idle ? .infinity : 50)
                .background(Color.green).cornerRadius(authState == .idle ? 12 : 25)
            }.disabled(authState != .idle)
            VStack {
                Text("OR").font(.caption).foregroundColor(.secondary).padding(.vertical, 10)
                HStack(spacing: 16) { SocialLoginButton(iconName: "g.circle.fill", text: "Google"); SocialLoginButton(iconName: "camera.circle.fill", text: "Instagram") }
            }.opacity(authState == .idle ? 1 : 0)
            Spacer()
            HStack { Text("Don't have an account?"); Button("Sign Up") { onNavigateToSignUp() }.fontWeight(.bold).foregroundColor(.green) }.opacity(authState == .idle ? 1 : 0)
        }.padding()
    }
    
    private func handleSignIn() {
        withAnimation(.spring()) { authState = .authenticating }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { withAnimation(.spring()) { authState = .success } }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { onSignIn(User(id: UUID(), fullName: "David Kim", university: "UCLA", email: email, profilePhoto: "", badges: mockBadges)) }
    }
}
