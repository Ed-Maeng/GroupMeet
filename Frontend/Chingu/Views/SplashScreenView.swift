//
//  SplashScreenView.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var scale = 0.7
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            VStack {
                Image(systemName: "person.3.fill").font(.system(size: 80))
                Text("Chingu").font(.system(size: 40, weight: .bold))
            }
            .foregroundColor(.white).scaleEffect(scale).opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) { self.scale = 1.0; self.opacity = 1.0 }
            }
        }
    }
}
