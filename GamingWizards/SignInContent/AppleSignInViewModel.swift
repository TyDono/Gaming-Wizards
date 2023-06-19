//
//  AppleSignInViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/4/22.
//

import AuthenticationServices
import CryptoKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

//not used
@MainActor class AppleSignInViewModel: ObservableObject {
    
    @AppStorage(Constants.appStorageStringLogStatus) var log_Status = false
    
//    @Published var signInState: SignInState = .signedOut
    @Published var isLoading: Bool = false
    
    
    
    
}
