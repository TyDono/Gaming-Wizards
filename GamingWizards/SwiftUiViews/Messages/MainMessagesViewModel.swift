//
//  MainMessagesViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/31/23.
//

import Foundation
import UIKit
import SwiftUI
import Firebase
import Combine

extension MainMessagesView {
    class MainMessagesViewModel: ObservableObject {
        @ObservedObject var user: UserObservable
        @ObservedObject var coreDataController: CoreDataController
        @Published var timeUtilsService: TimeUtilsService
        private let firestoreService: FirebaseFirestoreService
        var diskSpace: DiskSpaceHandler
        @Published var mainUserProfileImage: UIImage?
        @Published var onlineStatus: Bool = true
        @Published var savedFriendEntities: [FriendEntity] = []
        @Published var selectedContact: FriendEntity?
        @Published var friendEntityImageCache: [String: UIImage] = [:]
        @Published var arrayOfFriendEntities: [FriendEntity]
        private var friendCancellable: AnyCancellable?
        
        init(
            user: UserObservable = UserObservable.shared,
            coreDataController: CoreDataController = CoreDataController.shared,
            firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper.shared,
            diskSpace: DiskSpaceHandler = DiskSpaceHandler(),
            timeUtilsService: TimeUtilsService = TimeUtils(),
            listOfFriends: [FriendEntity]
        ) {
            self.user = user
            self.coreDataController = coreDataController
            self.timeUtilsService = timeUtilsService
            self.firestoreService = firestoreService
            self.diskSpace = diskSpace
            self.arrayOfFriendEntities = listOfFriends
            mainUserProfileImage = loadImageFromDisk(imageString: user.profileImageString)
        }
        
        func callForCoreDataEntities() async {
            self.friendCancellable = coreDataController.fetchFriendEntitiesPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }) { friends in
                    self.arrayOfFriendEntities = friends
                }
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
        
        func onlineStatusCircleWasTapped(toId: String) async {
            onlineStatus.toggle()
            
            // Post MVP
            /*
            do {
                try await firestoreService.changeOnlineStatus(onlineStatus: onlineStatus, toId: toId, fromId: user.id)
                
            } catch {
                print("ERROR, FAILED TO CHANGE ONLINE STATUS: ")
                onlineStatus.toggle()
                return
            }
             */
        }
        
    }
}
