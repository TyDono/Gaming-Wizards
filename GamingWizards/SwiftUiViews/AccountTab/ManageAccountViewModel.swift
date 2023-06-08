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
        @ObservedObject var user = UserObservable()
        @Published var accountDeleteErrorAlertIsShowing: Bool = false
        @Published var settingsIsActive: Bool = false
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        @Published var displayName: String = ""
        @Published var email: String = ""
        @Published var about: String = ""
        @Published var profileImageString: String = ""
        @Published var isSaveChangesButtonIsActive: Bool = false
        @Published var emailIsNotValid: Bool = false
        @Published var accountInformationSavedAlertIsActive: Bool = false
        @Published var accountInformationChangedErrorAlertIsActive: Bool = false
        @Published var isShowingImagePicker = false
        @Published var profileImage: UIImage?
        @Published var didProfileImageChange: Bool = false
        @Published var isProfileUploading: Bool = false
        @Published var uploadProfileProgress: Double = 0.0
        let firestoreDatabase = Firestore.firestore()
        let firebaseStorage = Storage.storage()
        
        func saveProfileImageToDisc() {
            guard let image = profileImage else { return }

            guard let data = image.jpegData(compressionQuality: 1.0) else { return }

            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(profile_Image_String!)
            do {
                try data.write(to: fileURL)
                print("Image saved to disk.")
            } catch {
                print("ERROR SAVING PROFILE IMAGE TO DISC: \(error.localizedDescription)")
            }
        }
        
        func loadProfileImageFromDisk() {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(profile_Image_String!)

            if let imageData = try? Data(contentsOf: fileURL),
               let loadedImage = UIImage(data: imageData) {
                profileImage = loadedImage
            } else {
                print("Failed to load image from disk")
            }
        }
        
        func saveProfileImageToClod() {
            // ?????
        }


        
        func loadProfileImageFromFirebaseStorage() {
            // use this in viewing other people's profile
        }
        
        func uploadProfileImageToFirebaseStorage() {
            guard let image = profileImage else { return }
            guard let imageString = profile_Image_String else { return }
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            let storageRef = firebaseStorage.reference().child("profileImages/\(imageString)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = storageRef.putData(imageData, metadata: metadata) { metadata, err in
                if let error = err {
                    print("ERROR UPLOADING IMAGE TO STORAGE: \(error.localizedDescription)")
                } else {
                    print("Image uploaded successfully")
                    self.saveProfileImageToDisc()
                }
                self.isProfileUploading = false
                self.accountInformationSavedAlertIsActive = true
            }
            isProfileUploading = true
            
            uploadTask.observe(.progress) { snapshot in
                guard let progress = snapshot.progress else { return }
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                self.uploadProfileProgress = percentComplete
            }
        }
        
        func updateUserInfo() {
            let currentUser = Auth.auth().currentUser
            guard let userId = currentUser?.uid else { return }
            let path = firestoreDatabase.collection(Constants.users).document(userId)
            path.updateData([
                Constants.userFirstName: self.firstName,
                Constants.userLastName: self.lastName,
                Constants.userDisplayName: self.displayName,
                Constants.userAbout: self.about
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
            
            self.isSaveChangesButtonIsActive = false
            if isProfileUploading == false {
                self.accountInformationSavedAlertIsActive = true
            }
        }
        
        func deleteProfileImage() {
            let storageRef = firebaseStorage.reference().child(profile_Image_String!)
            storageRef.delete { err in
              if let error = err {
                  print("ERROR DELETING PROFILE IMAGE FROM CLOUD: \(error.localizedDescription)")
              } else {
                // delete locally
                  let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                  let fileURL = documentsDirectory.appendingPathComponent(self.profile_Image_String!)
                  do {
                      try FileManager.default.removeItem(at: fileURL)
                      self.profileImage = nil
                  } catch {
                      print("ERROR DELETING PROFILE IMAGE FROM DISC: \(error.localizedDescription)")
                  }
              }
            }
        }
        
        func deleteUserAccount() {
            let currentUser = Auth.auth().currentUser
            guard let userId = currentUser?.uid else { return }
            let path = firestoreDatabase.collection(Constants.users).document(userId)
            
            currentUser?.delete { err in
                if let error = err {
                    self.accountDeleteErrorAlertIsShowing = true
                    print("ACCOUNT DELETION ERROR: \(error.localizedDescription)")
                    // have pop up here
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
