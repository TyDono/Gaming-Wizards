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

 class SearchResultsDetailViewModel: ObservableObject {
    @ObservedObject var user: UserObservable
    @Published var FriendRequestAlreadySentIsTrue: Bool = false
    @Published var noFriendExistsAlertIsShowing: Bool = false
    @Published var detailedFriendViewIsShowing: Bool = false
    @Published var friends: [Friend] = [] // not being called. not used. ?
    @Published var friend: FriendEntity? // not being called. not used. ?
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
    
    //moved to search results View Model
    func convertUserToFriendDataBinding(displayName: String,
                                        friendUserID: String,
                                        profileImageString: String,
                                        isFavorite: Bool,
                                        isFriend: Bool) -> Binding<FriendEntity> {
        let friendEntity: FriendEntity = coreDataController.convertToFriendEntity2(
            displayName: displayName,
            friendUserID: friendUserID,
            profileImageString: profileImageString,
            isFavorite: isFavorite,
            isFriend: isFriend
        )
        // Create a Binding for the FriendEntity
        let binding = Binding(get: {
            friendEntity
        }, set: { newValue in
            // Update properties of friendEntity when the binding is set
//            friendEntity.friendCodeID = newValue.friendCodeID
            friendEntity.id = newValue.id
            friendEntity.displayName = newValue.displayName
            friendEntity.isFriend = newValue.isFriend
            friendEntity.isFavorite = newValue.isFavorite
            friendEntity.imageString = newValue.imageString
        })
        return binding
    }

     
     func friendRequestButtonWasTapped(newFriend: User,
                                        friendProfileImage: UIImage) async throws {
         do {
             let friend = try await fbFirestoreService.sendFriendRequest(newFriend: newFriend)
             

             diskSpaceHandler.saveProfileImageToDisc(imageString: friend.imageString,
                                                     image: friendProfileImage)
             
             let recentMessageResult = await fbFirestoreService.createDualRecentMessage(toId: newFriend.id, chatUserDisplayName: newFriend.displayName ?? "", fromId: user.id)
             
             switch recentMessageResult {
             case .success:
                 coreDataController.addFriend(friendUserID: friend.id,
                                              friendDisplayName: friend.displayName,
                                              isFriend: false, isFavorite: false,
                                              profileImageString: friend.imageString)
             case .failure(let error):
                 print("ERROR CREATING DUAL RECENT MESSAGE: \(error.localizedDescription)")
             }
         } catch {
             print("ERROR SENDING FRIEND REQUEST: \(error.localizedDescription)")
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
