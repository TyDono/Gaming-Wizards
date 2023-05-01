//
//  FriendsListViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/21/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import CoreData

//extension FriendListView {
    @MainActor class FriendListViewModel: ObservableObject {
        @Published var friendList: [Friend] = []
        @Published var addFriendAlertIsShowing: Bool = false
        @Published var friendIDTextField: String = ""
        @Published var friendIDName: String = ""
        @Published var friendName: String = ""
        @Published var FriendRequestAlreadySentIsTrue: Bool = false
        @Published var noFriendExistsAlertIsShowing: Bool = false
        @Published var detailedFriendViewIsShowing: Bool = false
        @Published var friends: [Friend] = []
        @Published var friend: FriendEntity?
        @Published var detailedFriendViewIsDismissed: Bool = false
        @State var friendDisplayName: String = ""
        @State var friendID: String = ""
        @State var isFriend: Bool = false
        @State var isFavorite: Bool = false
        @AppStorage("user_Id") var user_Id: String?
        @AppStorage("user_Friend_Code_ID") var user_Friend_Code_ID: String?
        @AppStorage("display_Name") var display_Name: String?
//        var friendDisplayName: String = ""
        let coreDataController = CoreDataController.shared
        let authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
        let firestoreDatabase = Firestore.firestore()
        
        func friendWasTapped(friend: FriendEntity) {
            self.friend = friend
            detailedFriendViewIsShowing.toggle() // remove later
        }
        
        func sendFriendRequest() {
            firestoreDatabase.collection("users").whereField("friendCodeID", isEqualTo: friendIDTextField)
                .getDocuments() { (querySnapshot, err) in
                    if let error = err {
                        self.noFriendExistsAlertIsShowing = true
                        print("Error getting documents: \(error)")
                    } else {
                        self.noFriendExistsAlertIsShowing = false
                        //if no document exist have an alert
                        for document in querySnapshot!.documents {
                            let friendUserID = document.data()["id"] as? String ?? "No user id found"
                            guard let userID = self.user_Id else { return }
                            guard let userFriendCodeID = self.user_Friend_Code_ID else { return }
                            guard let displayName = self.display_Name else { return }
                            let newFriend: Friend = Friend(friendCodeID: userFriendCodeID, friendUserID: userID, friendDisplayName: displayName, isFriend: false, isFavorite: false)
                            let newPath = self.firestoreDatabase.collection("users").document(friendUserID).collection("friendList").document(userFriendCodeID)
                            
                            newPath.getDocument { (document, error) in
                                if ((document?.exists) == false) {
                                    newPath.setData(newFriend.friendDictionary)
                                } else {
                                    self.FriendRequestAlreadySentIsTrue = true
                                }
                            }
                        }
                    }
                }
        }
        
//        func fetchUser(uid: String, completion: @escaping (Friend) -> ()) { //THIS ISN'T BEING USED AT ALL.
//            firestoreDatabase.collection("Users").document(uid).getDocument { (doc, err) in
//                if let error = err {
//                    print("ERROR FETCHING USER'S FRIENDS \(error.localizedDescription)")
//                    return
//                }
//                guard let user = doc else { return }
//                
//                let displayName = user.data()?["displayName"] as? String ?? "No Username"
//                let friendID = user.data()?["friendID"] as? String ?? "No image URL"
//                
//                DispatchQueue.main.async {
//                    completion(Friend(friendCodeID: "", friendDisplayName: ""))
//                }
//            }
//        }
        
        //MARK: Detailed Friend List View
        
        func acceptFriendRequest() {
            guard let friendCodeIDRequest = friend?.friendCodeID else { return }
            guard let friendUserID = friend?.friendUserID else { return }
            guard let userID = user_Id else { return }
            guard let userFriendCodeID = user_Friend_Code_ID else { return }
            guard let displayName = display_Name else { return }
//            guard let friendUserID
            let friends = coreDataController.savedFriendEntities
            let newFriend = Friend(friendCodeID: userFriendCodeID, friendUserID: userID, friendDisplayName: displayName, isFriend: true, isFavorite: false)
            let friendPath = firestoreDatabase.collection("users").document(friendUserID).collection("friendList").document(userFriendCodeID) //goes to the friend and adds you to their friend list
            let userPath = firestoreDatabase.collection("users").document(userID).collection("friendList").document(friendCodeIDRequest) // goes to your friend list and changes isFriend to true

            userPath.updateData([
                "isFriend": true
            ]) { err in
                if let error = err {
                    print("ERROR ACCEPTING FRIEND REUEST: \(error.localizedDescription)")
                    return
                } else {
                    //a the path searches for the other user. goes to their friend list and adds you to their friend list with is friend as true

                    friendPath.setData(newFriend.friendDictionary)
                    friends.forEach {
                        if $0.friendCodeID == friendCodeIDRequest {
                            $0.setValue(true, forKey: "isFriend")
                            self.coreDataController.saveFriendData()
                        }
                    }
                }
            }
        }

        func denyFriendRequest() {
            guard let friendCodeID = friend?.friendCodeID else { return }
            guard let userID = user_Id else { return }// go into their cloud and remove them as a friend
            let friends = coreDataController.savedFriendEntities
            friends.forEach {
                if $0.friendCodeID == friendCodeID {
//                    guard let friendDisplayName = $0.friendDisplayName else { return }
//                    guard let friendUserID = $0.friendUserID else { return }
//                    let isFriend = $0.isFriend
//                    let isFavorite = $0.isFavorite
//                    let friend = Friend(friendCodeID: friendCodeID, friendUserID: friendUserID, friendDisplayName: friendDisplayName, isFriend: isFriend, isFavorite: isFavorite)
                    authenticationViewModel.deleteFriendInFirestore(friend: $0, userID: userID)
//                    coreDataController.deleteFriend(friend: $0, userID: userID)
                } else {
                    //have an alert i guess
                }
            }
        }

        func removeFriend() { //remove friend from your cloud, their cloud and locally
            guard let friendCodeIDRequest = friend?.friendCodeID else { return }
            guard let userID = user_Id else { return }// go into their cloud and remove them as a friend
            let friends = coreDataController.savedFriendEntities
            friends.forEach {
                if $0.friendCodeID == friendCodeIDRequest {
//                    guard let friendDisplayName = $0.friendDisplayName else { return }
//                    guard let friendUserID = $0.friendUserID else { return }
//                    let isFriend = $0.isFriend
//                    let isFavorite = $0.isFavorite
//                    let friend = Friend(friendCodeID: friendCodeIDRequest, friendUserID: friendUserID,  friendDisplayName: friendDisplayName, isFriend: isFriend, isFavorite: isFavorite) //not used
                    authenticationViewModel.deleteFriendInFirestore(friend: $0, userID: userID)
                    detailedFriendViewIsDismissed = true
//                    coreDataController.deleteFriend(friend: $0, userID: userID)
                    // segue back to friend list view
                } else {
                    //have an alert I guess
                }
            }
        }

        
    }
//}
