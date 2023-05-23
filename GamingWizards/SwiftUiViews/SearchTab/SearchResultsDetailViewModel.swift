//
//  SearchResultsDetailViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/18/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import CoreData

@MainActor class SearchResultsDetailViewModel: ObservableObject {
    @AppStorage("user_Id") var user_Id: String?
    @AppStorage("user_Friend_Code_ID") var user_Friend_Code_ID: String?
    @AppStorage("display_Name") var display_Name: String?
    @Published var users: [User] = []
    @Published var FriendRequestAlreadySentIsTrue: Bool = false
    @Published var noFriendExistsAlertIsShowing: Bool = false
    @Published var detailedFriendViewIsShowing: Bool = false
    @Published var friends: [Friend] = []
    @Published var friend: FriendEntity?
    @Published var detailedFriendViewIsDismissed: Bool = false
    let firestoreDatabase = Firestore.firestore()
    
    func sendFriendRequest(selectedUserID: String) {
        guard let userFriendCode = user_Friend_Code_ID else { return }
        let path = firestoreDatabase.collection(Constants.users).document(selectedUserID).collection(Constants.friendList).document(userFriendCode)
        let newFriend = Friend(friendCodeID: user_Friend_Code_ID!, friendUserID: user_Id!, friendDisplayName: display_Name!, isFriend: false, isFavorite: false) //this should be the current user's info
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
