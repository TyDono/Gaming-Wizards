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
//    @ObservedObject var user = UserObservable()
    @ObservedObject var user = UserObservable.shared
//    @Published var users: [User] = []
    @Published var FriendRequestAlreadySentIsTrue: Bool = false
    @Published var noFriendExistsAlertIsShowing: Bool = false
    @Published var detailedFriendViewIsShowing: Bool = false
    @Published var friends: [Friend] = []
    @Published var friend: FriendEntity?
    @Published var detailedFriendViewIsDismissed: Bool = false
    @Published var displayName: String? = ""
    @Published var profileImage: UIImage?
    let firestoreDatabase = Firestore.firestore()
    let fbStorageHelper = FirebaseStorageHelper()
    
    func sendFriendRequest(selectedUserID: String) {
//        guard let userFriendCode = user.friendCodeID else { return }
        let path = firestoreDatabase.collection(Constants.usersString).document(selectedUserID).collection(Constants.userFriendList).document(user.friendCodeID)
        let newFriend = Friend(friendCodeID: user.friendCodeID, friendUserID: user.id, friendDisplayName: user.displayName!, isFriend: false, isFavorite: false) //this should be the current user's info
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
