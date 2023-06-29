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
    @Published var users: [User] = []
    @Published var FriendRequestAlreadySentIsTrue: Bool = false
    @Published var noFriendExistsAlertIsShowing: Bool = false
    @Published var detailedFriendViewIsShowing: Bool = false
    @Published var friends: [Friend] = []
    @Published var friend: FriendEntity?
    @Published var detailedFriendViewIsDismissed: Bool = false
    let firestoreDatabase = Firestore.firestore()
    
    func sendFriendRequest(selectedUserID: String) {
        guard let userFriendCode = user.friendCodeID else { return }
        let path = firestoreDatabase.collection(Constants.users).document(selectedUserID).collection(Constants.userFriendList).document(userFriendCode)
        let newFriend = Friend(friendCodeID: user.friendCodeID!, friendUserID: user.id, friendDisplayName: user.displayName!, isFriend: false, isFavorite: false) //this should be the current user's info
        path.getDocument { (documentSnapshot, err) in
            if let error = err {
                print("Error retrieving document: \(error.localizedDescription)")
            } else if documentSnapshot?.exists == true {
                self.FriendRequestAlreadySentIsTrue = true
            } else {
                path.setData(newFriend.friendDictionary)
            }
        }
    }
    
}
