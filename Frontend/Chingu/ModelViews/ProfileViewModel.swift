import SwiftUI
import JWTDecode

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorAlert: AlertItem?

    func fetchUser(with token: String) {
        do {
            // Decode the JWT
            let jwt = try decode(jwt: token)
            
            // Extract the userID from the token's claims
            guard let userId = jwt["user_id"].integer else {
                print("Error: User ID ('user_id') not found in token or is not an integer.")
                self.errorAlert = AlertItem(message: "Could not identify user from token.")
                return
            }

            // Build the URL dynamically with the extracted ID
            guard let url = URL(string: "http://localhost:8080/api/v1/users/\(userId)") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let decoder = JSONDecoder()

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorAlert = AlertItem(message: "Network Error: \(error.localizedDescription)")
                        return
                    }

                    guard let data = data else {
                        self.errorAlert = AlertItem(message: "No data received from server.")
                        return
                    }

                    do {
                        self.user = try decoder.decode(User.self, from: data)
                    } catch {
                        self.errorAlert = AlertItem(message: "Could not load profile. The data might be outdated.")
                        print("Decoding Error:", error)
                    }
                }
            }.resume()

        } catch {
            print("Error decoding token: \(error)")
        }
    }
}
