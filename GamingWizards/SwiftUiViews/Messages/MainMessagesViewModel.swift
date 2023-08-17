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
        var diskSpace: DiskSpaceHandler
        @Published var mainUserProfileImage: UIImage?
        @Published var isDetailedMessageViewShowing: Bool = false
        @Published var friends: [FriendEntity] = []

        init(
            user: UserObservable = UserObservable.shared,
            coredataController: CoreDataController = CoreDataController.shared,
            diskSpace: DiskSpaceHandler = DiskSpaceHandler()
        ) {
            self.user = user
            self.coredataController = coredataController
            self.diskSpace = diskSpace
            
            mainUserProfileImage = diskSpace.loadProfileImageFromDisk(imageString: user.profileImageString)
        }
        
        func retrieveProfileImageFromDisk() {
            mainUserProfileImage = diskSpace.loadProfileImageFromDisk(imageString: user.profileImageString)
        }
        
    }
}
