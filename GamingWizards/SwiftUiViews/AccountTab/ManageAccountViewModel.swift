//
//  ManageAccountViewModel.swift
//  Foodiii
//
//  Created by Tyler Donohue on 10/18/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth


extension ManageAccountView {
    @MainActor class ManageAccountViewModel: ObservableObject {
        @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
        @AppStorage("first_Name") var first_Name: String?
        @AppStorage("last_Name") var last_Name: String?
        @AppStorage("user_Email") var user_Email: String?
        @AppStorage("user_Friend_Code_ID") var user_Friend_Code_ID: String?
        @AppStorage("display_Name") var display_Name: String?
        @ObservedObject var user = UserObservable()
        @Published var accountDeleteErrorAlertIsShowing: Bool = false
        @Published var settingsIsActive: Bool = false
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        @Published var displayName: String = ""
        @Published var email: String = ""
        @Published var isSaveChangesButtonIsActive: Bool = false
        @Published var emailIsNotValid: Bool = false
        @Published var accountInformationSavedAlertIsActive: Bool = false
        @Published var accountInformationChangedErrorAlertIsActive: Bool = false
        let firestoreDatabase = Firestore.firestore()
        
        func updateUserInfo() {
            let currentUser = Auth.auth().currentUser
            guard let userId = currentUser?.uid else { return }
            let path = firestoreDatabase.collection("users").document(userId)
            path.updateData([
                "displayName": self.displayName
//                "firstName": self.firstName, // have these user defaults to published. then have user defaults be saved once successful
//                "lastName": self.lastName
            ]) { err in
                if let error = err {
                    self.accountInformationChangedErrorAlertIsActive = true
                    print("ERROR UPDATING FIRESTORE DOCUMENT: \(error)")
                } else {
                    self.saveUserToUserDefaults()
                    self.isSaveChangesButtonIsActive = false
                    print("Document successfully updated")
                }
            }
        }
        
        private func saveUserToUserDefaults() {
            self.display_Name = self.displayName
//            self.first_Name = self.firstName
//            self.last_Name = self.lastName
//            self.user_Email = self.email // used later when users can change their email
            self.accountInformationSavedAlertIsActive = true
        }
        
        func deleteUserAccount() {
            let currentUser = Auth.auth().currentUser
            guard let userId = currentUser?.uid else { return }
            let path = firestoreDatabase.collection("users").document(userId)
            
            currentUser?.delete { err in
                if let error = err {
                    self.accountDeleteErrorAlertIsShowing = true
                    print("ACCOUNT DELETION ERROR: \(error.localizedDescription)")
                } else {
                    path.delete() { err in
                        if let error = err {
                            print("FIRESTORE DELETION ERROR: \(error.localizedDescription)")
                        } else {
                            self.authenticationViewModel.signOut()
                        }
                    }
                }
            }
        }
        
    }
}
