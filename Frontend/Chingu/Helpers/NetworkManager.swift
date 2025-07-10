import SwiftUI

// Custom Error enum for more specific network error handling
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .requestFailed(let error):
            return "The network request failed. Please check your connection. (\(error.localizedDescription))"
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .decodingError:
            return "Failed to decode the server's response."
        case .serverError(let statusCode, let message):
            return "Server error with status code \(statusCode): \(message)"
        }
    }
}

// A class to handle network requests
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func authenticate(isSignUp: Bool, email: String, password: String, name: String?, school: String?, preference: String?, completion: @escaping (Result<String, Error>) -> Void) {
        // --- Replace this with your actual backend URL ---
        let urlString = isSignUp ? "http://localhost:8080/api/v1/signup/" : "http://localhost:8080/api/v1/login/"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Encode the appropriate request body
        do {
            if isSignUp {
                // Ensure all signup fields are present
                guard let name = name, !name.isEmpty,
                      let school = school, !school.isEmpty,
                      let preference = preference, !preference.isEmpty else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please fill out all fields for sign up."])))
                    return
                }
                let signUpPayload = SignUpRequest(preferenceID: 1, email: name, password: school, name: email, school: password)
                request.httpBody = try JSONEncoder().encode(signUpPayload)
            } else {
                let loginPayload = LoginRequest(email: email, password: password)
                request.httpBody = try JSONEncoder().encode(loginPayload)
            }
        } catch {
            completion(.failure(NetworkError.decodingError(error)))
            return
        }

        // Perform the network request        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                // Try to decode an error message from the server body
                var errorMessage = "An unknown server error occurred."
                if let data = data, let errorDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let message = errorDict["message"] as? String {
                    errorMessage = message
                }
                completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorMessage)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            // Decode the successful response to get the token
            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                completion(.success(authResponse.token))
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }
        task.resume()
    }
}
