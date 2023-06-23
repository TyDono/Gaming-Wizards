//
//  ManageAccountViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/18/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


extension ManageAccountView {
    @MainActor class ManageAccountViewModel: ObservableObject {
        @ObservedObject var user = UserObservable()
        @StateObject private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
        
        @Published var accountDeleteErrorAlertIsShowing: Bool = false
        @Published var settingsIsActive: Bool = false
        @Published var firstName: String = ""
        @Published var lastName: String = ""
        @Published var displayName: String = ""
        @Published var email: String = ""
        @Published var about: String = ""
        @Published var profileImageString: String = "" // not called
        @Published var profileImage: UIImage?
        @Published var didProfileImageChange: Bool = false
        @Published var isSaveChangesButtonIsActive: Bool = false
        @Published var emailIsNotValid: Bool = false
        @Published var accountInformationSavedAlertIsActive: Bool = false
        @Published var accountInformationChangedErrorAlertIsActive: Bool = false
        @Published var isShowingImagePicker = false
        @Published var isProfileUploading: Bool = false
        @Published var uploadProfileProgress: Double = 0.0
        @Published var groupSize: String = ""
        @Published var userAge: String = ""
        @Published var userLocation: String = ""
        @Published var userListOfGames: String = "" // this or
        @Published var listOfGames: [String] = [] //that
        @Published var userAvailability: String = ""
        @Published var userTitle: String = ""
        @Published var isPayToPlay: Bool = false
        @Published var userIsSolo: Bool = true
        
        let firestoreDatabase = Firestore.firestore()
        let firebaseStorage = Storage.storage()
        
        func saveProfileImageToDisc() {
            guard let image = profileImage else { return }

            guard let data = image.jpegData(compressionQuality: 1.0) else { return }

            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(user.profileImageString!)
            do {
                try data.write(to: fileURL)
                print("Image saved to disk.")
            } catch {
                print("ERROR SAVING PROFILE IMAGE TO DISC: \(error.localizedDescription)")
            }
        }
        
        func loadProfileImageFromDisk() {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(user.profileImageString!)

            if let imageData = try? Data(contentsOf: fileURL),
               let loadedImage = UIImage(data: imageData) {
                profileImage = loadedImage
            } else {
                print("Failed to load image from disk, or no image")
            }
        }
        
        func loadProfileImageFromFirebaseStorage() {
            // use this in viewing other people's profile
        }
        
        func uploadProfileImageToFirebaseStorage() {
            guard let image = profileImage else { return }
            guard let imageString = user.profileImageString else { return }
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
                self.didProfileImageChange = false
                self.isSaveChangesButtonIsActive = false
            }
        }
        
        func updateUserInfo() {
            // if no internet make a pop up appear
            let currentUser = Auth.auth().currentUser
            guard let userId = currentUser?.uid else { return }
            let path = firestoreDatabase.collection(Constants.users).document(userId)
            path.updateData([
                Constants.userFirstName: self.firstName,
                Constants.userLastName: self.lastName,
                Constants.userDisplayName: self.displayName,
                Constants.userLocation: self.userLocation,
                Constants.userGames: self.userListOfGames,
                Constants.userListOfGames: self.listOfGames,
                Constants.userGroupSize: self.groupSize,
                Constants.userAge: self.userAge,
                Constants.userAbout: self.about,
                Constants.userAvailability: self.userAvailability,
                Constants.userTitle: self.userTitle,
                Constants.userPayToPlay: self.isPayToPlay,
                Constants.userIsSolo: self.userIsSolo
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
            user.displayName = displayName
            user.firstName = firstName
            user.lastName = lastName
            user.about = about
            user.title = userTitle
            user.availability = userAvailability
            user.isPayToPlay = isPayToPlay
            user.groupSize = groupSize
            user.listOfGames = listOfGames
            user.location = userLocation
            user.age = userAge
            user.isSolo = userIsSolo
            
            self.isSaveChangesButtonIsActive = false
            if isProfileUploading == false {
                self.accountInformationSavedAlertIsActive = true
            }
        }
        
        func deleteProfileImage() {
            let storageRef = firebaseStorage.reference().child(user.profileImageString!)
            storageRef.delete { err in
              if let error = err {
                  print("ERROR DELETING PROFILE IMAGE FROM CLOUD: \(error.localizedDescription)")
              } else {
                // delete locally
                  let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                  let fileURL = documentsDirectory.appendingPathComponent(self.user.profileImageString!)
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
