//
//  FriendsListViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/21/22.
//

import SwiftUI
import FirebaseFirestore
import CoreData
import Security

//extension FriendListView {
    @MainActor class FriendListViewModel: ObservableObject {
//        @ObservedObject var user = UserObservable()
        @ObservedObject var user = UserObservable.shared
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
//        var friendDisplayName: String = ""
        let coreDataController = CoreDataController.shared
        let authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
        let firestoreDatabase = Firestore.firestore()
        
        func friendWasTapped(friend: FriendEntity) {
            self.friend = friend
            detailedFriendViewIsShowing.toggle() // remove later
        }
        
        func sendFriendRequest() {
            firestoreDatabase.collection(Constants.users).whereField("friendCodeID", isEqualTo: friendIDTextField)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let error = err {
                        self.noFriendExistsAlertIsShowing = true
                        print("Error getting documents: \(error)")
                    } else {
                        self.noFriendExistsAlertIsShowing = false
                        //if no document exist have an alert
                        for document in querySnapshot!.documents {
                            let friendUserID = document.data()[Constants.userID] as? String ?? "No user id found"
                             let userID = self.user.id //else { return }
//                            guard let userFriendCodeID = self.user.friendCodeID else { return }
                            guard let displayName = self.user.displayName else { return }
                            let newFriend: Friend = Friend(friendCodeID: self.user.friendCodeID, friendUserID: userID, friendDisplayName: displayName, isFriend: false, isFavorite: false)
                            let newPath = self.firestoreDatabase.collection(Constants.users).document(friendUserID).collection(Constants.userFriendList).document(self.user.friendCodeID)
                            
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
//                let friendCodeID = user.data()?["friendCodeID"] as? String ?? "No image URL"
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
             let userID = user.id //else { return }
//            guard let userFriendCodeID = user.friendCodeID else { return }
            guard let displayName = user.displayName else { return }
//            guard let friendUserID
            let friends = coreDataController.savedFriendEntities
            let newFriend = Friend(friendCodeID: user.friendCodeID, friendUserID: userID, friendDisplayName: displayName, isFriend: true, isFavorite: false)
            let friendPath = firestoreDatabase.collection(Constants.users).document(friendUserID).collection(Constants.userFriendList).document(user.friendCodeID) //goes to the friend and adds you to their friend list
            let userPath = firestoreDatabase.collection(Constants.users).document(userID).collection(Constants.userFriendList).document(friendCodeIDRequest) // goes to your friend list and changes isFriend to true

            userPath.updateData([
                Constants.isFriend: true
            ]) { err in
                if let error = err {
                    print("ERROR ACCEPTING FRIEND REUEST: \(error.localizedDescription)")
                    return
                } else {
                    //a the path searches for the other user. goes to their friend list and adds you to their friend list with is friend as true

                    friendPath.setData(newFriend.friendDictionary)
                    friends.forEach {
                        if $0.friendCodeID == friendCodeIDRequest {
                            $0.setValue(true, forKey: Constants.isFriend)
                            self.coreDataController.saveFriendData()
                        }
                    }
                }
            }
        }

        func denyFriendRequest() {
            guard let friendCodeID = friend?.friendCodeID else { return }
             let userID = user.id //else { return }// go into their cloud and remove them as a friend
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
             let userID = user.id //else { return }// go into their cloud and remove them as a friend
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
