//
//  SplashScreenView.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

struct SplashScreenView: View {
    // State variables to control the animation
    @State private var scale = 0.7
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            // You can customize the background color here
            Color.PrimaryGreen
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Image(systemName: "studentdesk") // A relevant icon for your app
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                    
                    Text("ChinGoo")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .scaleEffect(scale) // Apply the scale animation
                .opacity(opacity) // Apply the opacity animation
                .onAppear {
                    // This triggers the animation when the view appears
                    withAnimation(.easeIn(duration: 1.5)) {
                        self.scale = 1.0
                        self.opacity = 1.0
                    }
                }
            }
        }
    }
}

