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
import Combine

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
     @Published var isShowingSendMessageConfirmationAlert: Bool = false
     @Published var isFailedToSendMessageShowing: Bool = false
     private let convertUserToFriend = ConvertToFriend()
     let fbFirestoreService: FirebaseFirestoreService
     let fbStorageHelper: FirebaseStorageHelper
     let coreDataController: CoreDataController
     let diskSpaceHandler: DiskSpaceHandler
     private var cancellables = Set<AnyCancellable>()
     
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
     
     func friendRequestButtonWasTapped(newFriend: User,
                                       friendProfileImage: UIImage) async throws {
         let senderFriendInfo = convertUserToFriend.convertUserObservableToFriend(userObservable: user)
         let receiverFriendInfo = convertUserToFriend.convertUserToFriend(user: newFriend)
         // move most of this to view model
         let friend = await fbFirestoreService.sendFriendRequest(senderFriendInfo: senderFriendInfo, receiverFriendInfo: receiverFriendInfo)
         switch friend {
         case .success(let friend):
             break
             // don't save freinds locally. jsut save in cloud and listen'
//             diskSpaceHandler.saveProfileImageToDisc(imageString: friend.imageString,
//                                                     image: friendProfileImage)
//             coreDataController.saveFriend(friend: friend)
//                 .receive(on: DispatchQueue.main)
//                 .sink(receiveCompletion: { completion in
//                     switch completion {
//                     case .finished:
//                         break
//                     case .failure(let error):
//                         print("FAILED TO SAVE FRIEND TO CORE DATA: \(error)")
//                     }
//                 }, receiveValue: { savedEntity in
//                     // DO SOMETHING WITH THE SAVED ENTITY IF NEEDED
//                 })
//                 .store(in: &cancellables)
             
         case .failure(let error):
             // have pop up
             print("ERROR CREATING DUAL RECENT MESSAGE: \(error.localizedDescription)")
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
