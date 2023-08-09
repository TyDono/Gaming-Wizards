//
//  FirebaseAuthHelper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/2/23.
//

import SwiftUI
import FirebaseAuth

class FirebaseAuthHelper: NSObject, ObservableObject {
    
    let auth: Auth
    
    static let shared = FirebaseAuthHelper()
    
    override init() {
        self.auth = Auth.auth()
        
        super.init()
    }
    
}
