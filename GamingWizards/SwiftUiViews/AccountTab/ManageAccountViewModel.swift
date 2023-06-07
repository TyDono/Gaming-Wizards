//
//  ManageAccountViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/18/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


extension ManageAccountView {
    @MainActor class ManageAccountViewModel: ObservableObject {
        @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
        @AppStorage("first_Name") var first_Name: String?
        @AppStorage("last_Name") var last_Name: String?
        @AppStorage("user_Email") var user_Email: String?
        @AppStorage("user_Friend_Code_ID") var user_Friend_Code_ID: String?
        @AppStorage("display_Name") var display_Name: String?
        @AppStorage("about") var about_user: String?
        @AppStorage("profile_Image_String") var profile_Image_String: String?
        @AppStorage("saved_Profile_Image") var saved_Profile_Image: String?
//        @AppStorage("profile_Image") var profile_Image: UIImage?
        @ObservedObject var user = UserObservable()
        @Published var accountDeleteErrorAlertIsShowing: Bool = false
        @Published var settingsIsActive: Bool = false
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        @Published var displayName: String = ""
        @Published var email: String = ""
        @Published var about: String = ""
        @Published var profileImageUrl: String = ""
        @Published var isSaveChangesButtonIsActive: Bool = false
        @Published var emailIsNotValid: Bool = false
        @Published var accountInformationSavedAlertIsActive: Bool = false
        @Published var accountInformationChangedErrorAlertIsActive: Bool = false
        @Published var isShowingImagePicker = false
        @Published var profileImage: UIImage?
        @Published var didProfileImageChange: Bool = false
        let firestoreDatabase = Firestore.firestore()
        let firebaseStorage = Storage.storage()
        
        func saveProfileImageToDefaults() {
            guard let image = profileImage else { return }

            if let imageData = image.jpegData(compressionQuality: 0.6) {
                saved_Profile_Image = imageData.base64EncodedString()
                self.didProfileImageChange = false
            }
        }
        
        func saveProfileImageToClod() {
            // ?????
        }

        func loadProfileImage() {
            if let imageData = Data(base64Encoded: saved_Profile_Image ?? "") {
                profileImage = UIImage(data: imageData)
            }
        }
        
        func loadProfileImageFromFirebaseStorage() {
            // use this in viewing other people's profile
        }
        
        func uploadProfileImageToFirebaseStorage() {
            guard let image = profileImage else { return }
            guard let imageString = profile_Image_String else { return }
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
            let storageRef = firebaseStorage.reference().child("profileImages/\(imageString)")
            if let imageName = profile_Image_String {
                let imageRef = storageRef.child(imageName)
                
                _ = imageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("ERROR UPLOADING IMAGE TO FIREBASE STORAGE: \(error.localizedDescription)")
                    } else {
                        self.saveProfileImageToDefaults()
                        print("IT WENT IN BB")
                    }
                }
            }
        }
        
        func updateUserInfo() {
            let currentUser = Auth.auth().currentUser
            guard let userId = currentUser?.uid else { return }
            let path = firestoreDatabase.collection(Constants.users).document(userId)
            path.updateData([
                "firstName": self.firstName,
                "lastName": self.lastName,
                "displayName": self.displayName,
                "about": self.about
            ]) { err in
                if let error = err {
                    self.accountInformationChangedErrorAlertIsActive = true
                    print("ERROR UPDATING FIRESTORE DOCUMENT: \(error)")
                } else {
                    if self.didProfileImageChange == true {
                        self.uploadProfileImageToFirebaseStorage()
                    }
                    self.saveUserToUserDefaults()
                }
            }
        }
        
        private func saveUserToUserDefaults() {
            self.display_Name = self.displayName
            self.first_Name = self.firstName
            self.last_Name = self.lastName
//            self.user_Email = self.email // used later when users can change their email
            self.about_user = self.about
            self.profile_Image_String = self.profileImageUrl
            
            self.isSaveChangesButtonIsActive = false
            self.accountInformationSavedAlertIsActive = true
        }
        
        func deleteUserAccount() {
            let currentUser = Auth.auth().currentUser
            guard let userId = currentUser?.uid else { return }
            let path = firestoreDatabase.collection(Constants.users).document(userId)
            
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
