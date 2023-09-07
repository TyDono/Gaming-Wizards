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
//        private let firestoreService: FirebaseFirestoreService
        var diskSpace: DiskSpaceHandler
        @Published var mainUserProfileImage: UIImage?
        @Published var isDetailedMessageViewShowing: Bool = false
        
        @Published var savedFriendEntities: [FriendEntity] = []
        @Published var selectedContact: FriendEntity?
        @Published var selectedContact2: RecentMessage?
        @Published var friendEntityImageCache: [String: UIImage] = [:]
        @Published var recentMessages: [RecentMessage]
        
        init(
            user: UserObservable = UserObservable.shared,
            coredataController: CoreDataController = CoreDataController.shared,
            fbFirestoreHelper: FirebaseFirestoreHelper = FirebaseFirestoreHelper.shared,
//            firestoreService: FirebaseFirestoreService,
            diskSpace: DiskSpaceHandler = DiskSpaceHandler(),
            recentMessages: [RecentMessage]
        ) {
            self.user = user
            self.coredataController = coredataController
            self.fbFirestoreHelper = fbFirestoreHelper
//            self.firestoreService = firestoreService
            self.diskSpace = diskSpace
            self.recentMessages = recentMessages
            
            savedFriendEntities = self.coredataController.savedFriendEntities
//            mainUserProfileImage = diskSpace.loadProfileImageFromDisk(imageString: user.profileImageString)
            mainUserProfileImage = loadImageFromDisk(imageString: user.profileImageString)
            callFetchRecentMessages()
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
        
        func callFetchRecentMessages() {
            fbFirestoreHelper.fetchRecentMessages { [weak self] err, recentMessages in
                if let error = err {
                    print("ERROR FETCHING RECENT MESSAGES: \(error.localizedDescription)")
                } else {
                    if let self = self {
                        self.recentMessages.append(contentsOf: recentMessages)
                    }
                }
            }
        }
        
    }
}
