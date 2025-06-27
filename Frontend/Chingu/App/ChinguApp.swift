//
//  ChinguApp.swift
//  Chingu
//
//  Created by David Kim on 6/25/25.
//

import SwiftUI

@main
struct ChinguApp: App {
    @State private var isShowingSplash = true
       
       var body: some Scene {
           WindowGroup {
               ZStack {
                   // If isShowingSplash is true, show the splash screen
                   if isShowingSplash {
                       SplashScreenView()
                           .onAppear {
                               // Wait for 2.5 seconds, then hide the splash screen
                               DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                   withAnimation {
                                       self.isShowingSplash = false
                                   }
                               }
                           }
                   } else {
                       // Otherwise, show the main content of your app
                       ContentView()
                           .transition(.opacity) // Add a gentle fade-in transition
                   }
               }
           }
       }
   }
