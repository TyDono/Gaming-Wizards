//
//  ViewPersonalAccountViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

extension ViewPersonalAccountView {
    class ViewPersonalAccountViewModel: ObservableObject {
//        @ObservedObject var user = UserObservable()
        @ObservedObject var user = UserObservable.shared
        @Published var profileImage: UIImage?
        @Published var isShowingEditAccountView: Bool = false
        
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
