//
//  KeychainHelper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/14/23.
//

import SwiftUI
import Security

struct KeychainHelper {
    static let service = "GamingWizardsAppService"
    
    
    static func saveUserID(userID: String) {
        if let data = userID.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("ERROR SAVING USER ID TO KEYCHAIN: \(status)")
            } else {
                UserObservable.shared.id = getUserID() ?? "NO USER ID"
            }
        }
    }
    
    static func getUserID() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data, let userID = String(data: data, encoding: .utf8) {
            return userID
        } else {
            print("Error retrieving user ID from Keychain: \(status)")
            return nil
        }
    }
    
    static func clearKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error deleting Keychain items. Status code: \(status)")
        }
    }
    
}

