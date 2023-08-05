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
//    let fbStorageHelper = FirebaseStorageHelper.shared
    
    static let shared = FirebaseFirestoreHelper()
    
    override init() {
        self.firestore = Firestore.firestore()
        
        super.init()
    }

    
    // HAVE MORE DONE IN HERE
    func deleteItemFromArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?, String) -> Void) {
        let documentRef = firestore.collection(collectionName).document(documentField)
        documentRef.updateData([
            arrayField: FieldValue.arrayRemove([itemName])
        ]) { error in
            if let error = error {
                print("ERROR REMOVING ITEM FROM ARRAY: \(error)")
            } else {
                completion(nil, itemName)
//                self?.user.listOfGames?.removeAll { $0 == itemName}
//                print("Item removed successfully from the array.")
            }
        }
    }
    
    func addItemToArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?, String) -> Void) {
        let documentRef = firestore.collection(collectionName).document(documentField)
        documentRef.updateData([
            arrayField: FieldValue.arrayUnion([itemName])
        ]) { error in
            if let error = error {
                print("ERROR ADDING ITEM FROM ARRAY: \(error)")
            } else {
                completion(nil, itemName)
//                self?.user.listOfGames?.append(itemName)
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
                let friendCodeID = data[Constants.userFriendCode] as? String ?? ""
                let listOfGames = data[Constants.userListOfGamesString] as? [String] ?? [""]
                let groupSize = data[Constants.userGroupSize] as? String ?? ""
                let age = data[Constants.userAge] as? String ?? ""
                let about = data[Constants.userAbout] as? String ?? ""
                let availability = data[Constants.userAvailability] as? String ?? ""
                let title = data[Constants.userTitle] as? String ?? ""
                let payToPlay = data[Constants.userPayToPlay] as? Bool ?? false
                let isSolo = data[Constants.userIsSolo] as? Bool ?? true
                
                return User(id: id,
                            displayName: displayName,
                            email: email,
                            location: location,
                            profileImageString: profileImageString,
                            friendCodeID: friendCodeID,
                            listOfGames: listOfGames,
                            groupSize: groupSize,
                            age: age, about: about,
                            availability: availability,
                            title: title,
                            isPayToPlay: payToPlay,
                            isSolo: isSolo)
            }
            
            return users
        } catch {
            print("ERROR FETCHING SEARCHED FOR USERS: \(error.localizedDescription)")
            throw error
        }
    }
    
    func sendFriendRequest(newFriend: User, completion: @escaping (Error?, Friend) -> Void) {
        let friendListPath = firestore.collection(Constants.usersString).document(newFriend.id).collection(Constants.userFriendList).document(self.user.id)
        let yourInfoPath = self.firestore.collection(Constants.usersString).document(self.user.id).collection(Constants.userFriendList).document(newFriend.id)
                let yourFriendInfo = Friend(id: (self.user.id),
                                            friendCodeID: self.user.friendCodeID,
                                            displayName: self.user.displayName ?? "",
                                            isFriend: false,
                                            isFavorite: false,
                                            imageString: self.user.profileImageString)
                let theirFriendInfo = Friend(id: newFriend.id,
                                             friendCodeID: newFriend.friendCodeID,
                                             displayName: newFriend.displayName ?? "",
                                             isFriend: false,
                                             isFavorite: false,
                                             imageString: newFriend.profileImageString)
                friendListPath.setData(yourFriendInfo.friendDictionary)
                yourInfoPath.setData(theirFriendInfo.friendDictionary)
                completion(nil, theirFriendInfo)
    }
    
}
