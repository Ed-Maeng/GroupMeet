//
//  SocialLoginButton.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct SocialLoginButton: View {
    let iconName: String; let text: String
    var body: some View {
        Button(action: {}) {
            HStack { Image(systemName: iconName).font(.title2); Text(text).fontWeight(.medium) }
            .foregroundColor(.primary).frame(height: 50).frame(maxWidth: .infinity)
            .background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
        }
    }
}
