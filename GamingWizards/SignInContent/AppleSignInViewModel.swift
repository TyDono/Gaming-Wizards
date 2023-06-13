//
//  AppleSignInViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/4/22.
//

import Foundation
import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

//not used
@MainActor class AppleSignInViewModel: ObservableObject {
    
    @AppStorage(Constants.appStorageStringLogStatus) var log_Status = false
    @AppStorage(Constants.appStorageStringUserEmail) var user_Email: String?
    @AppStorage(Constants.appStorageStringUserFirstName) var first_Name: String?
    @AppStorage(Constants.appStorageStringUserLastName) var last_Name: String?
    @AppStorage(Constants.appStorageStringUserFriendCodeID) var user_Id: String?
    @AppStorage(Constants.appStorageStringUserDisplayName) var display_Name: String?
    
//    @Published var signInState: SignInState = .signedOut
    @Published var isLoading: Bool = false
    
    
    
    
}
