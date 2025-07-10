import SwiftUI

struct ProfilePage: View {
    @StateObject private var viewModel = ProfileViewModel()

    var onLogOut: () -> Void
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("jwtToken") private var token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMCwiaXNzIjoiZ3JvdXBtZWV0LWFwaSIsImV4cCI6MTc1MjIxMTUxNCwiaWF0IjoxNzUyMTI1MTE0fQ.BV3PWH_glCu3RheaGMi6lBqcpRc-XcdsrshJpo9LeYo"

    var body: some View {
        NavigationView {
            if let userProfile = viewModel.user {
                Form {
                    Section {
                        VStack {
                            Button(action: { print("Change profile picture tapped") }) {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray.opacity(0.5))
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.green)
                                        .background(Color(UIColor.systemBackground).clipShape(Circle()))
                                }
                            }
                            .padding()

                            Text(userProfile.name).font(.title).bold()
                            Text(userProfile.school).foregroundColor(.secondary)

                        }.frame(maxWidth: .infinity)
                         .listRowInsets(EdgeInsets())
                         .listRowBackground(Color.clear)
                    }

                    Section(header: Text("Badges")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(userProfile.badges) { badge in
                                    VStack {
                                        Image(systemName: badge.iconName)
                                            .font(.title)
                                            .foregroundColor(badge.color)
                                            .frame(width: 60, height: 60)
                                            .background(badge.color.opacity(0.15))
                                            .clipShape(Circle())
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
                }
                .navigationTitle("Profile")
            } else {
                // Show a loading indicator while fetching data
                ProgressView("Loading Profile...")
                    .navigationTitle("Profile")
            }
        }
        .onAppear {
             viewModel.fetchUser(with: token)
         }
        .alert(item: $viewModel.errorAlert) { alertItem in
            Alert(
                title: Text("Error"),
                message: Text(alertItem.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
