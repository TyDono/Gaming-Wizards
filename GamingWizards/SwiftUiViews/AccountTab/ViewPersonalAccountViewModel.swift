//
//  ViewPersonalAccountViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

extension ViewPersonalAccountView {
    class ViewPersonalAccountViewModel: ObservableObject {
//        @AppStorage(Constants.appStorageStringUserProfileImageString) var profile_Image_String: String?
//        @AppStorage(Constants.appStorageStringUserTitle) var user_title: String?
        @Published var profileImage: UIImage?
        @ObservedObject var user = UserObservable()
        
        func loadProfileImageFromDisk() {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(user.profileImageString!)

            if let imageData = try? Data(contentsOf: fileURL),
               let loadedImage = UIImage(data: imageData) {
                profileImage = loadedImage
            } else {
                print("Failed to load image from disk")
            }
        }
        
    }
}
