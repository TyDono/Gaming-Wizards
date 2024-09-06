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
        private let firebaseAuthService: FirebaseAuthService = FirebaseAuthHelper.shared
        var diskSpace: DiskSpaceHandler
        @Published var mainUserProfileImage: UIImage?
        @Published var onlineStatus: Bool = true
        @Published var savedFriendEntities: [FriendEntity] = []
        @Published var selectedContact: Friend?
        @Published var friendEntityImageCache: [String: UIImage] = [:]
        @Published var arrayOfFriendEntities: [FriendEntity]
        @Published var listOfFriends: [Friend] = []
        private var friendCancellable: AnyCancellable?
        private var userFriendListListener: ListenerRegistration?
        
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
        
        func callListenForChangesInUserFriendListSubCollection() async {
            guard let uid = firebaseAuthService.getCurrentUid() else { return }
            userFriendListListener = firestoreService.listenForChangesInSubcollection(
                collectionPath: "userFriendList",
                documentId: uid,
                subcollectionPath: "listOfFriends",
                type: Friend.self) { [weak self] (data, error) in
                    guard let self = self else { return }
                if let listOfFriendsData = data {
                    DispatchQueue.main.async { [weak self] in
                        self?.listOfFriends = listOfFriendsData
                    }
                } else if let error = error {
                    print("Error listening for changes: \(error)")
                }
            }
        }
        
        func stopListening() {
            userFriendListListener?.remove()
        }
        
        func cancelFriend() {
            friendCancellable?.cancel()
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
