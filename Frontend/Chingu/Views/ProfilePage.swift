//
//  ProfilePage.swift
//  Chingu
//
//  Created by David Kim on 7/5/25.
//

import SwiftUI

struct ProfilePage: View {
    @Binding var user: User
    var onLogOut: () -> Void
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        Button(action: { print("Change profile picture tapped") }) {
                            ZStack(alignment: .bottomTrailing) {
                                Image(systemName: "person.circle.fill").resizable().aspectRatio(contentMode: .fit).frame(width: 100, height: 100).foregroundColor(.gray.opacity(0.5))
                                Image(systemName: "pencil.circle.fill").font(.title).foregroundColor(.green).background(Color(UIColor.systemBackground).clipShape(Circle()))
                            }
                        }.padding()
                        Text(user.fullName).font(.title).bold()
                        Text(user.university).foregroundColor(.secondary)
                    }.frame(maxWidth: .infinity).listRowInsets(EdgeInsets()).listRowBackground(Color.clear)
                }
                Section(header: Text("Badges")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(user.badges) { badge in
                                VStack {
                                    Image(systemName: badge.iconName).font(.title).foregroundColor(badge.color)
                                        .frame(width: 60, height: 60).background(badge.color.opacity(0.15)).clipShape(Circle())
                                    Text(badge.name).font(.caption)
                                }
                            }
                        }.padding(.vertical, 4)
                    }.listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) { Text("Dark Mode") }
                }
                Section(header: Text("Account")) {
                    Button("Change Password") {}
                    Button(action: onLogOut) { Text("Log Out").foregroundColor(.red) }
                }
            }.navigationTitle("Profile")
        }
    }
}
