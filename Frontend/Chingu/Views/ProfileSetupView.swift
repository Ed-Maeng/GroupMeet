//
//  ProfileSetupView.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct ProfileSetupView: View {
    var onComplete: () -> Void
    @State private var year: String = "Freshman"; @State private var major: String = ""; @State private var selectedInterests: Set<String> = []
    let collegeYears = ["Freshman", "Sophomore", "Junior", "Senior", "Graduate"]

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome to Chingu!").font(.largeTitle).bold()
                Text("Let's set up your profile to help you connect with others.").foregroundColor(.secondary)
            }
            VStack(spacing: 20) {
                Picker("What is your current year?", selection: $year) { ForEach(collegeYears, id: \.self) { Text($0) } }.pickerStyle(.segmented)
                TextField("What's your major?", text: $major).padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(12)
            }
            VStack(alignment: .leading) {
                Text("Select your interests").font(.headline)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                        ForEach(interests) { interest in
                            Button(action: {
                                if selectedInterests.contains(interest.name) { selectedInterests.remove(interest.name) } else { selectedInterests.insert(interest.name) }
                            }) {
                                VStack {
                                    Image(systemName: interest.iconName).font(.title)
                                    Text(interest.name).font(.caption).fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity, minHeight: 90).padding(4)
                                .background(selectedInterests.contains(interest.name) ? Color.green.opacity(0.2) : Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(selectedInterests.contains(interest.name) ? Color.green : Color.clear, lineWidth: 2))
                            }.buttonStyle(.plain)
                        }
                    }
                }
            }
            Spacer()
            Button(action: onComplete) {
                Text("Done").fontWeight(.bold).foregroundColor(.white).frame(height: 50).frame(maxWidth: .infinity).background(Color.green).cornerRadius(12)
            }
        }.padding().transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}
