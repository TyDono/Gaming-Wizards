//
//  MainMessagesViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/31/23.
//

import Foundation
import UIKit
import SwiftUI

extension MainMessagesView {
    @MainActor class MainMessagesViewModel: ObservableObject {
        @ObservedObject var user: UserObservable
        @ObservedObject var coredataController: CoreDataController
        @ObservedObject var fbFirestoreHelper: FirebaseFirestoreHelper
        var diskSpace: DiskSpaceHandler
        @Published var mainUserProfileImage: UIImage?
        @Published var isDetailedMessageViewShowing: Bool = false
        
        @Published var savedFriendEntities: [FriendEntity] = []
        @Published var selectedContact: FriendEntity?
        @Published var friendEntityImageCache: [String: UIImage] = [:]

        init(
            user: UserObservable = UserObservable.shared,
            coredataController: CoreDataController = CoreDataController.shared,
            fbFirestoreHelper: FirebaseFirestoreHelper = FirebaseFirestoreHelper.shared,
            diskSpace: DiskSpaceHandler = DiskSpaceHandler()
        ) {
            self.user = user
            self.coredataController = coredataController
            self.fbFirestoreHelper =  fbFirestoreHelper
            self.diskSpace = diskSpace
            
            savedFriendEntities = self.coredataController.savedFriendEntities
//            mainUserProfileImage = diskSpace.loadProfileImageFromDisk(imageString: user.profileImageString)
            mainUserProfileImage = loadImageFromDisk(imageString: user.profileImageString)
        }
        
        func loadImageFromDisk(imageString: String) -> UIImage? {
            if let cachedImage = friendEntityImageCache[imageString] {
                return cachedImage
            } else {
                if let image = diskSpace.loadProfileImageFromDisk(imageString: imageString) {
                    friendEntityImageCache[imageString] = image
                    return image
                }
            }
            return nil
        }
        
        func retrieveProfileImageFromDisk() { // not used
            mainUserProfileImage = diskSpace.loadProfileImageFromDisk(imageString: user.profileImageString)
        }
        
    }
}
