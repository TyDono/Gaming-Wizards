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
//        @ObservedObject var user = UserObservable.shared
//        @StateObject private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
//        @ObservedObject var locationManager: LocationManager = LocationManager()
//        var diskSpace = DiskSpaceHandler()
        @ObservedObject var user: UserObservable
        @ObservedObject var fbFirestoreHelper: FirebaseFirestoreHelper
        @ObservedObject var fbStorageHelper: FirebaseStorageHelper
        private let fbAuthService: FirebaseAuthService
        @ObservedObject var authenticationViewModel: AuthenticationViewModel
        @ObservedObject var locationManager: LocationManager
        let diskSpaceHandler: DiskSpaceHandler
        
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
        @Published var userLatitude: Double = 0.0
        @Published var userLongitude: Double = 0.0
        @Published var userLocation: String = ""
        @Published var listOfGames: [String] = []
        @Published var userAvailability: String = ""
        @Published var userTitle: String = ""
        @Published var isPayToPlay: Bool = false
        @Published var userIsSolo: Bool = true
        @Published var isSearchButtonShowing: Bool = false
        @Published var addGameButtonWasTapped: Bool = false
        @Published var searchBarDropDownNotificationText: String = ""
        @Published var isSearchError: Bool = false
        @Published var isManageListOfGamesViewShowing: Bool = false
        @Published var isImageSizeExceedingLimitAlert: Bool = false
        @Published var isDisplayNameTextFieldBlank: Bool = false
        
        init(
            authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM,
            user: UserObservable = UserObservable.shared,
            fbFirestoreHelper: FirebaseFirestoreHelper = FirebaseFirestoreHelper.shared,
            fbStorageHelper: FirebaseStorageHelper = FirebaseStorageHelper.shared,
            fbAuthService: FirebaseAuthService = FirebaseAuthHelper.shared,
            diskSpaceHandler: DiskSpaceHandler = DiskSpaceHandler(),
            locationManager: LocationManager = LocationManager()
        ) {
            self.authenticationViewModel = authenticationViewModel
            self.user = user
            self.fbFirestoreHelper =  fbFirestoreHelper
            self.fbStorageHelper = fbStorageHelper
            self.fbAuthService = fbAuthService
            self.diskSpaceHandler = diskSpaceHandler
            self.locationManager = locationManager
        }
        
        func getUserLocation(latitude: Double, longitude: Double, city: String, state: String ) {
            userLocation = "\(city), \(state)"
            userLatitude = latitude
            userLongitude = longitude
            isSaveChangesButtonIsActive = true
        }
        
        func saveProfileImageToDisc() {
            guard let image = profileImage else { return }
            diskSpaceHandler.saveProfileImageToDisc(imageString: user.profileImageString, image: image)
        }
        
        func retrieveProfileImageFromDisk() {
           profileImage = diskSpaceHandler.loadProfileImageFromDisk(imageString: user.profileImageString)
        }
        
        func uploadProfileImageToFirebaseStorage() {
            guard let image = profileImage else { return }
            let maxSizeInBytes: Int64 = 6 * 1024 * 1024
            let minSizeInBytes: Int64 = Int64(0.8 * 1024 * 1024)
            
            guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
            var compressionQuality: CGFloat = 1.0
            
            if Int64(imageData.count) > minSizeInBytes {
                let targetCompressionQuality = CGFloat(minSizeInBytes) / CGFloat(imageData.count)
                compressionQuality = max(targetCompressionQuality, 0.5)
            } else if Int64(imageData.count) > maxSizeInBytes {
                isImageSizeExceedingLimitAlert = true
                return
            }
            
            guard let compressedImageData = image.jpegData(compressionQuality: compressionQuality) else { return }
            
            let storageRef = fbStorageHelper.storage.reference().child("profileImages/\(user.profileImageString)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = storageRef.putData(compressedImageData, metadata: metadata) { [weak self] metadata, err in
                guard let self = self else { return }
                if let error = err {
                    print("ERROR UPLOADING IMAGE TO STORAGE: \(error.localizedDescription)")
                } else {
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
            guard self.firstName == "" else {
                isDisplayNameTextFieldBlank = true
                return
            }
            let currentUser = Auth.auth().currentUser
            guard let userId = currentUser?.uid else { return }
            let path = fbFirestoreHelper.firestore.collection(Constants.usersString).document(userId)
            path.updateData([
                Constants.userFirstName: self.firstName,
                Constants.userLastName: self.lastName,
                Constants.userDisplayName: self.displayName,
                Constants.userLatitude: self.userLatitude,
                Constants.userLongitude: self.userLongitude,
                Constants.userLocation: self.userLocation,
//                Constants.userListOfGamesString: self.listOfGames,
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
        
        func userChangedImage() {
            isShowingImagePicker = true
            didProfileImageChange = true
            isSaveChangesButtonIsActive = true
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
//            user.listOfGames = listOfGames
            user.latitude = userLatitude
            user.longitude = userLongitude
            user.location = userLocation
            user.age = userAge
            user.isSolo = userIsSolo
            
            self.isSaveChangesButtonIsActive = false
            if isProfileUploading == false {
                self.accountInformationSavedAlertIsActive = true
            }
        }
        
        func deleteProfileImage() {
            let storageRef = fbStorageHelper.storage.reference().child(user.profileImageString)
            storageRef.delete { err in
              if let error = err {
                  print("ERROR DELETING PROFILE IMAGE FROM CLOUD: \(error.localizedDescription)")
              } else {
                // delete locally
                  let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                  let fileURL = documentsDirectory.appendingPathComponent(self.user.profileImageString)
                  do {
                      try FileManager.default.removeItem(at: fileURL)
                      self.profileImage = nil
                  } catch {
                      print("ERROR DELETING PROFILE IMAGE FROM DISC: \(error.localizedDescription)")
                  }
              }
            }
        }
        
        func deleteUserAccountAndFirestore() async {
            
            let result = await fbAuthService.deleteUserAccount()
            if result == true {
                self.accountDeleteErrorAlertIsShowing = true
            } else {
                await fbFirestoreHelper.deleteUserFirebaseAccount(userId: user.id)
            }
        }
        
    }
}
