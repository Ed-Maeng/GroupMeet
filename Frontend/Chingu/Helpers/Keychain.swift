import SwiftUI
import Security

// A helper class to interact with the iOS Keychain for securely storing the JWT
class KeychainHelper {
    static let standard = KeychainHelper()
    private let service = "com.yourapp.Chingu" // Should be unique to your app bundle

    private init() {}

    // Function to save the JWT token
    func save(token: String, for account: String) {
        guard let data = token.data(using: .utf8) else { return }
        
        // Query to find existing items for the account
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        // Attributes for the new item
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]

        // If an item for the account already exists, update it.
        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        } else {
            // Otherwise, add a new item.
            var newItem = query
            newItem[kSecValueData as String] = data
            SecItemAdd(newItem as CFDictionary, nil)
        }
    }

    // Function to retrieve the JWT token
    func getToken(for account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) {
                return token
            }
        }
        return nil
    }

    // Function to delete the JWT token
    func deleteToken(for account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
