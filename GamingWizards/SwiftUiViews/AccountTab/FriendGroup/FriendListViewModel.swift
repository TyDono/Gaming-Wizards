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
class FriendListViewModel: ObservableObject {
    /*
    @ObservedObject var user: UserObservable
    @Published var friendList: [Friend] = []
    @Published var addFriendAlertIsShowing: Bool = false
    @Published var friendCodeIDTextField: String = ""
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
    
    let coreDataController: CoreDataController
    let authenticationViewModel: AuthenticationViewModel
    let firestoreDatabase: Firestore
    
    // Dependency injection
    init(
        user: UserObservable,
        coreDataController: CoreDataController = CoreDataController.shared,
        authenticationViewModel: AuthenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM,
        firestoreDatabase: Firestore = Firestore.firestore()
    ) {
        self.user = user
        self.coreDataController = coreDataController
        self.authenticationViewModel = authenticationViewModel
        self.firestoreDatabase = firestoreDatabase
    }
        
        func friendWasTapped(friend: FriendEntity) {
            self.friend = friend
            detailedFriendViewIsShowing.toggle() // remove later
        }
        
        func sendFriendRequest() {
            firestoreDatabase.collection(Constants.usersString).whereField("friendCodeID", isEqualTo: friendCodeIDTextField)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let error = err {
                        self.noFriendExistsAlertIsShowing = true
                        print("ERROR GETTING DOCUMENTS ON A FRIENDS REQUEST BEING SENT: \(error)")
                    } else {
                        self.noFriendExistsAlertIsShowing = false
                        //if no document exist have an alert
                        for document in querySnapshot!.documents {
                            let friendUserID = document.data()[Constants.userID] as? String ?? "No user id found"
                             let userID = self.user.id //else { return }
//                            guard let userFriendCodeID = self.user.friendCodeID else { return }
                            guard let displayName = self.user.displayName else { return }
                            let newFriend: Friend = Friend(id: userID,
                                                           displayName: displayName,
                                                           isFriend: false, isFavorite: false,
                                                           imageString: self.user.profileImageString)
                            let newPath = self.firestoreDatabase.collection(Constants.usersString).document(friendUserID).collection(Constants.userFriendList).document(self.user.id)
                            
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
//                    completion(Friend(friendCodeID: "", displayName: ""))
//                }
//            }
//        }
        
        //MARK: Detailed Friend List View
        
        func acceptFriendRequest() {
//            guard let friendCodeIDRequest = friend?.friendCodeID else { return }
            guard let friendUserID = friend?.id else { return }
             let userID = user.id //else { return }
//            guard let userFriendCodeID = user.friendCodeID else { return }
            guard let displayName = user.displayName else { return }
//            guard let friendUserID
            let friends = coreDataController.savedFriendEntities
            let newFriend = Friend(id: userID,
//                                   friendCodeID: user.friendCodeID,
                                   displayName: displayName,
                                   isFriend: true,
                                   isFavorite: false,
                                   imageString: user.profileImageString)
            let friendPath = firestoreDatabase.collection(Constants.usersString).document(friendUserID).collection(Constants.userFriendList).document(user.id) //goes to the friend and adds you to their friend list
            let userPath = firestoreDatabase.collection(Constants.usersString).document(userID).collection(Constants.userFriendList).document(friendUserID) // goes to your friend list and changes isFriend to true

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
                        if $0.id == friendUserID {
                            $0.setValue(true, forKey: Constants.isFriend)
//                            self.coreDataController.saveFriendData()
                        }
                    }
                }
            }
        }

        func denyFriendRequest() {
            guard let friendUserID = friend?.id else { return }
             let userID = user.id //else { return }// go into their cloud and remove them as a friend
            let friends = coreDataController.savedFriendEntities
            friends.forEach {
                if $0.id == friendUserID {
//                    guard let displayName = $0.displayName else { return }
//                    guard let friendUserID = $0.friendUserID else { return }
//                    let isFriend = $0.isFriend
//                    let isFavorite = $0.isFavorite
//                    let friend = Friend(friendCodeID: friendCodeID, friendUserID: friendUserID, displayName: displayName, isFriend: isFriend, isFavorite: isFavorite)
                    authenticationViewModel.deleteFriendInFirestore(friend: $0, userID: userID)
//                    coreDataController.deleteFriend(friend: $0, userID: userID)
                } else {
                    //have an alert i guess
                }
            }
        }

        func removeFriend() { //remove friend from your cloud, their cloud and locally
            guard let friendIdRequest = friend?.id else { return }
             let userID = user.id //else { return }// go into their cloud and remove them as a friend
            let friends = coreDataController.savedFriendEntities
            friends.forEach {
                if $0.id == friendIdRequest {
//                    guard let displayName = $0.displayName else { return }
//                    guard let friendUserID = $0.friendUserID else { return }
//                    let isFriend = $0.isFriend
//                    let isFavorite = $0.isFavorite
//                    let friend = Friend(friendCodeID: friendCodeIDRequest, friendUserID: friendUserID,  displayName: displayName, isFriend: isFriend, isFavorite: isFavorite) //not used
                    authenticationViewModel.deleteFriendInFirestore(friend: $0, userID: userID)
                    detailedFriendViewIsDismissed = true
//                    coreDataController.deleteFriend(friend: $0, userID: userID)
                    // segue back to friend list view
                } else {
                    //have an alert I guess
                }
            }
        }

        */
    }
//}
