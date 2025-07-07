//
//  FormField.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct FormField<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.caption).foregroundColor(.secondary)
            content.font(.headline)
            Divider()
        }
    }
}
