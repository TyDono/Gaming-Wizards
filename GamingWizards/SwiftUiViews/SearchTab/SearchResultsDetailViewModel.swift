//
//  SearchResultsDetailViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/18/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import CoreData

@MainActor class SearchResultsDetailViewModel: ObservableObject {
    @ObservedObject var user: UserObservable
    @Published var FriendRequestAlreadySentIsTrue: Bool = false
    @Published var noFriendExistsAlertIsShowing: Bool = false
    @Published var detailedFriendViewIsShowing: Bool = false
    @Published var friends: [Friend] = []
    @Published var friend: FriendEntity?
    @Published var detailedFriendViewIsDismissed: Bool = false
    @Published var displayName: String? = ""
    @Published var profileImage: UIImage?
    let fbFirestoreService: FirebaseFirestoreService
    let fbStorageHelper: FirebaseStorageHelper
    let coreDataController: CoreDataController
    let diskSpaceHandler: DiskSpaceHandler

    init(
        user: UserObservable = UserObservable.shared,
        fbFirestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper.shared,
        fbStorageHelper: FirebaseStorageHelper = FirebaseStorageHelper.shared,
        coreDataController: CoreDataController = CoreDataController.shared,
        diskSpaceHandler: DiskSpaceHandler = DiskSpaceHandler()
    ) {
        self.user = user
        self.fbFirestoreService = fbFirestoreService
        self.fbStorageHelper = fbStorageHelper
        self.coreDataController = coreDataController
        self.diskSpaceHandler = diskSpaceHandler
    }
    
    /*
    func sendFriendRequest(selectedUserID: String) { // not used
//        guard let userFriendCode = user.friendCodeID else { return }
        let path = fbFirestoreService.firestore.collection(Constants.usersString).document(selectedUserID).collection(Constants.userFriendList).document(user.friendCodeID)
        let newFriend = Friend(id: user.id, friendCodeID: user.friendCodeID,
                               displayName: user.displayName ?? "",
                               isFriend: false,
                               isFavorite: false,
                               imageString: user.profileImageString) //this should be the current user's info
        path.getDocument { [weak self] (documentSnapshot, err) in
            if let error = err {
                print("Error retrieving document: \(error.localizedDescription)")
            } else if documentSnapshot?.exists == true {
                guard let self = self else { return }
                self.FriendRequestAlreadySentIsTrue = true
            } else {
                path.setData(newFriend.friendDictionary)
            }
        }
    }
    */
     
    func friendRequestButtonWasTapped(newFriend: User, friendProfileImage: UIImage) async throws {
        do {
            let friend = try await fbFirestoreService.sendFriendRequest(newFriend: newFriend)
            
            coreDataController.addFriend(friendCodeID: friend.friendCodeID, friendUserID: friend.id, friendDisplayName: friend.displayName, isFriend: false, isFavorite: false, profileImageString: friend.imageString)
            diskSpaceHandler.saveProfileImageToDisc(imageString: friend.imageString, image: friendProfileImage)
            
            do {
                try await fbFirestoreService.createDualRecentMessage(toId: newFriend.id, chatUserDisplayName: newFriend.displayName ?? "", fromId: user.id)
            } catch {
                print("ERROR CREATING DUAL RECENT MESSAGE: \(error.localizedDescription)")
            }
        }
    }
    
    func callRetrieveUserProfileImage(selectedUserProfileImageString: String ) {
        fbStorageHelper.retrieveUserProfileImage(imageString: selectedUserProfileImageString) { [weak self]  uiimage in
            guard let self = self else { return }
            if let image = uiimage {
                self.profileImage = image
            }
        }
    }
    
    func optionalBindUser(displayName: String) {
        self.displayName = displayName
    }
    
}
