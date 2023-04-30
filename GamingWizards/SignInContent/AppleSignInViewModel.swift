//
//  AppleSignInViewModel.swift
//  Foodiii
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
    
    @AppStorage("log_Status") var log_Status = false
    @AppStorage("user_Email") var user_Email: String?
    @AppStorage("first_Name") var first_Name: String?
    @AppStorage("last_Name") var last_Name: String?
    @AppStorage("user_Id") var user_Id: String?
    @AppStorage("display_Name") var display_Name: String?
    
//    @Published var signInState: SignInState = .signedOut
    @Published var isLoading: Bool = false
    
    
    
    
}
