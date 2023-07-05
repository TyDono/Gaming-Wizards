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
        @StateObject var diskSpace = DiskSpace()
        @Published var profileImage: UIImage?
        @Published var isShowingEditAccountView: Bool = false
        
        func retrieveProfileImageFromDisk() {
            guard profileImage != nil else { return }
            profileImage = diskSpace.loadProfileImageFromDisk(imageString: user.profileImageString)
        }
        
    }
}
