//
//  FirebaseFirestoreHelper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/5/23.
//

import Foundation
import FirebaseFirestore

class FirebaseFirestoreHelper: NSObject {
//    let user = UserObservable.shared
//    let firestoreDatabase = Firestore.firestore()
    let firestore: Firestore
    let user = UserObservable.shared
    let coreDataController = CoreDataController.shared
    
    static let shared = FirebaseFirestoreHelper()
    
    override init() {
        self.firestore = Firestore.firestore()
        
        super.init()
    }

    
    // HAVE MORE DONE IN HERE
    func deleteItemFromArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?) -> Void) {
        let documentRef = firestore.collection(collectionName).document(documentField)
        documentRef.updateData([
            arrayField: FieldValue.arrayRemove([itemName])
        ]) { [weak self] error in
            if let error = error {
                print("ERROR REMOVING ITEM FROM ARRAY: \(error)")
            } else {
                self?.user.listOfGames?.removeAll { $0 == itemName}
//                print("Item removed successfully from the array.")
            }
        }
    }
    
    func addItemToArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?) -> Void) {
        let documentRef = firestore.collection(collectionName).document(documentField)
        documentRef.updateData([
            arrayField: FieldValue.arrayUnion([itemName])
        ]) { [weak self] error in
            if let error = error {
                print("ERROR ADDING ITEM FROM ARRAY: \(error)")
            } else {
                self?.user.listOfGames?.append(itemName)
//                print("Item added successfully to the array.")
            }
        }
    }
    
    func searchForMatchingGames(collectionName: String, whereField: String, gameName: String) async throws -> [User] {
        let gameQuery = firestore.collection(collectionName).whereField(whereField, arrayContains: gameName)
//            let gameQuery = firesStoreDatabase.collection(Constants.users).whereField(Constants.userListOfGamesString, arrayContains: gameName)
        
        do {
            let snapshot = try await gameQuery.getDocuments()
            let users = snapshot.documents.map { document -> User in
                let data = document.data()
                let id = data[Constants.userID] as? String ?? ""
                let displayName = data[Constants.userDisplayName] as? String ?? ""
                let email = data[Constants.userEmail] as? String ?? ""
                let location = data[Constants.userLocation] as? String ?? ""
                let profileImageString = data[Constants.userProfileImageString] as? String ?? ""
                let friendCodeID = data[Constants.userFriendID] as? String ?? ""
                let listOfGames = data[Constants.userListOfGamesString] as? [String] ?? [""]
                let groupSize = data[Constants.userGroupSize] as? String ?? ""
                let age = data[Constants.userAge] as? String ?? ""
                let about = data[Constants.userAbout] as? String ?? ""
                let availability = data[Constants.userAvailability] as? String ?? ""
                let title = data[Constants.userTitle] as? String ?? ""
                let payToPlay = data[Constants.userPayToPlay] as? Bool ?? false
                let isSolo = data[Constants.userIsSolo] as? Bool ?? true
                
                return User(id: id, displayName: displayName, email: email, location: location, profileImageString: profileImageString, friendCodeID: friendCodeID, listOfGames: listOfGames, groupSize: groupSize, age: age, about: about, availability: availability, title: title, isPayToPlay: payToPlay, isSolo: isSolo)
            }
            
            return users
        } catch {
            print("ERROR FETCHING SEARCHED FOR USERS: \(error.localizedDescription)")
            throw error
        }
    }
    
    func sendFriendRequest(friendId: String) { // rework to use the new friend id not friend code. add to both you and the sent user.
        let friendListPath = firestore.collection(Constants.usersString).document(friendId).collection(Constants.userFriendList).document(self.user.id)
        
        friendListPath.getDocument { [self] docSnapShot, err in
            if let error = err {
                print("sendFriendRequest ERROR: \(error.localizedDescription)")
            } else {
                let friendCodeID = docSnapShot?.data()?[Constants.friendCodeID] as? String ?? "No user friend code found"
                let friendUserID = docSnapShot?.data()?[Constants.userID] as? String ?? "No user id found"
                let friendDisplayName = docSnapShot?.data()?[Constants.friendDisplayName] as? String ?? ""
                
                let yourInfoPath = self.firestore.collection(Constants.usersString).document(self.user.id).collection(Constants.userFriendList).document(friendUserID)
                let yourFriendInfo = Friend(friendCodeID: self.user.friendCodeID,
                                            friendUserID: (self.user.id),
                                            friendDisplayName: self.user.displayName ?? "",
                                            isFriend: false,
                                            isFavorite: false)
                let theirFriendInfo = Friend(friendCodeID: friendCodeID,
                                                     friendUserID: friendUserID,
                                                     friendDisplayName: friendDisplayName,
                                                     isFriend: false,
                                                     isFavorite: false)
                friendListPath.setData(yourFriendInfo.friendDictionary)
                yourInfoPath.setData(theirFriendInfo.friendDictionary)
                self.coreDataController.addFriend(friendCodeID: friendCodeID, friendUserID: friendUserID, friendDisplayName: friendDisplayName, isFriend: false, isFavorite: false)
            }
        }
        /*
        
        firestoreDatabase.collection(Constants.usersString).whereField("friendCodeID", isEqualTo: friendId)
            .getDocuments() { [self] (querySnapshot, err) in
                if let error = err {
                    print("ERROR GETTING DOCUMENTS ON A FRIENDS REQUEST BEING SENT: \(error)")
                } else {
                    //if no document exist have an alert
                    for document in querySnapshot!.documents {
                        let friendUserID = document.data()[Constants.userID] as? String ?? "No user id found"
                         let userID = self.user.id //else { return }
//                            guard let userFriendCodeID = self.user.friendCodeID else { return }
                        guard let displayName = self.user.displayName else { return }
                        let newFriend: Friend = Friend(friendCodeID: self.user.friendCodeID, friendUserID: userID, friendDisplayName: displayName, isFriend: false, isFavorite: false)
                        let newPath = self.firestoreDatabase.collection(Constants.usersString).document(friendUserID).collection(Constants.userFriendList).document(self.user.friendCodeID)
                        
                        newPath.getDocument { (document, error) in
                            if ((document?.exists) == false) {
                                newPath.setData(newFriend.friendDictionary)
                            }
                        }
                    }
                }
            }
         */
    }
    
}
