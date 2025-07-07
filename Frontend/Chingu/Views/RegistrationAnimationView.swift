//
//  RegistrationAnimationView.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct RegistrationAnimationView: View {
    let onComplete: () -> Void
    let messages = ["Personalizing your experience...", "Almost done...", "Ready!"]
    @State private var currentMessageIndex = 0
    @State private var progress: CGFloat = 0.0
    
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            VStack(spacing: 20) {
                VStack {
                    HStack {
                        Image(systemName: "figure.walk")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .offset(x: progress * 250 - 15)
                        Spacer()
                    }
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).frame(height: 8).foregroundColor(Color(UIColor.systemGray5))
                        RoundedRectangle(cornerRadius: 4).frame(width: progress * 250, height: 8).foregroundColor(.green)
                    }
                }.frame(width: 250)
                
                Text(messages[currentMessageIndex])
                    .font(.title3).fontWeight(.medium).foregroundColor(.secondary)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .id("Message_\(currentMessageIndex)")
            }
            .onReceive(timer) { _ in
                if currentMessageIndex < messages.count - 1 {
                    withAnimation(.easeInOut) { currentMessageIndex += 1 }
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 4.5)) { progress = 1.0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    onComplete()
                }
            }
        }.transition(.opacity)
    }
}
