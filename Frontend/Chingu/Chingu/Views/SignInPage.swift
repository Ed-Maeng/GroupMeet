//
//  SignInPage.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

// An enum to manage the state of the authentication process for animations
enum AuthState {
    case idle
    case authenticating
    case success
}

struct SignInPage: View {
    // A state variable to drive the new animations
    @State private var authState: AuthState = .idle

    @State private var fullName: String = ""
    @State private var university: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = true

    var onSignInSuccess: (User) -> Void
    let universities = ["UCLA", "UCSD"]

    var body: some View {
        VStack {
            // This section will now hide during animation
            if authState == .idle {
                VStack {
                    Text("Chingu")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color("PrimaryGreen"))

                    Text("Find your friends, find your fun.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)
                }
                .transition(.opacity)
            }

            // This is the main container for the form and button
            VStack(spacing: 20) {
                // --- THIS IS THE MISSING CODE BLOCK THAT HAS BEEN ADDED BACK ---
                if authState == .idle {
                    VStack(spacing: 20) {
                        // Segmented Control for Sign Up / Log In
                        HStack {
                            Button(action: { isSignUp = true }) {
                                Text("Sign Up")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(isSignUp ? Color("PrimaryGreen") : .gray)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(isSignUp ? Color(UIColor.systemBackground) : Color.clear)
                                    .cornerRadius(10)
                                    .shadow(radius: isSignUp ? 3 : 0)
                            }
                            Button(action: { isSignUp = false }) {
                                Text("Log In")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(!isSignUp ? Color("PrimaryGreen") : .gray)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(!isSignUp ? Color(UIColor.systemBackground) : Color.clear)
                                    .cornerRadius(10)
                                    .shadow(radius: !isSignUp ? 3 : 0)
                            }
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.bottom, 20)

                        if isSignUp {
                            VStack {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .resizable().scaledToFit().frame(width: 80, height: 80)
                                    .foregroundColor(Color("SecondaryBlue"))
                                    .background(Color("SecondaryBlue").opacity(0.1))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color("PrimaryGreen").opacity(0.3), lineWidth: 2))
                                    .shadow(radius: 3).padding(.bottom, 10)

                                Button("Upload Profile Photo") {
                                    print("Upload photo tapped")
                                }
                                .font(.subheadline).foregroundColor(Color("PrimaryGreen")).padding(.bottom, 20)
                            }
                        }

                        VStack(spacing: 15) {
                            if isSignUp {
                                TextField("Full Name", text: $fullName)
                                    .padding().background(Color.gray.opacity(0.1)).cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                
                                Picker("Select University", selection: $university) {
                                    Text("Select University").tag("")
                                    ForEach(universities, id: \.self) { university in Text(university).tag(university) }
                                }
                                .pickerStyle(MenuPickerStyle()).padding().background(Color.gray.opacity(0.1)).cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            }

                            TextField("University Email (e.g., @ucla.edu)", text: $email)
                                .keyboardType(.emailAddress).autocapitalization(.none).padding()
                                .background(Color.gray.opacity(0.1)).cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))

                            SecureField("Password", text: $password)
                                .padding().background(Color.gray.opacity(0.1)).cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        }
                    }
                    .transition(.opacity)
                }
                // --- END OF THE MISSING CODE BLOCK ---
                
                // This is the animating button
                ZStack {
                    RoundedRectangle(cornerRadius: authState == .authenticating || authState == .success ? 35 : 15)
                        .fill(Color.PrimaryGreen)
                        .frame(width: authState == .idle ? nil : 70, height: 70)
                    
                    switch authState {
                    case .idle:
                        Text(isSignUp ? "Sign Up" : "Log In")
                            .font(.headline).fontWeight(.bold).foregroundColor(.white)
                            .transition(.opacity)
                    case .authenticating:
                        ProgressView().tint(.white).transition(.opacity)
                    case .success:
                        Image(systemName: "checkmark")
                            .font(.system(size: 24, weight: .bold)).foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .onTapGesture {
                    if authState == .idle {
                        handleAuth()
                    }
                }
                .padding(.top, 10)

                if !isSignUp && authState == .idle {
                    Button("Forgot Password?") {
                        print("Forgot password tapped")
                    }
                    .font(.subheadline).foregroundColor(Color("PrimaryGreen"))
                    .transition(.opacity)
                }
            }
            .padding(20)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: authState)


            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.05).ignoresSafeArea())
    }

    private func handleAuth() {
        withAnimation {
            authState = .authenticating
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                authState = .success
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let userData = User(fullName: isSignUp ? fullName : "John Doe", university: isSignUp ? university : "UCLA", email: email)
                onSignInSuccess(userData)
            }
        }
    }
}
