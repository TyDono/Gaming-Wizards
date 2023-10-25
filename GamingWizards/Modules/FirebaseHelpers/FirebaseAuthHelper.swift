//
//  FirebaseAuthHelper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/2/23.
//

import SwiftUI
import FirebaseAuth

protocol FirebaseAuthService {
    func deleteUserAccount() async -> Bool 
}

class FirebaseAuthHelper: NSObject, ObservableObject, FirebaseAuthService {
    
    let auth: Auth
    
    static let shared = FirebaseAuthHelper()
    
    override init() {
        self.auth = Auth.auth()
        
        super.init()
    }
    
    func deleteUserAccount() async -> Bool {
        guard let currentUser = auth.currentUser else { return true }
        
        return await withCheckedContinuation { continuation in
            currentUser.delete { err in
                if let error = err {
                    print("ERROR DELETING ACCOUNT: \(error.localizedDescription)")
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }



    
}
