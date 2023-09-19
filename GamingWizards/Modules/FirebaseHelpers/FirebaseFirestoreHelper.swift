//
//  FirebaseFirestoreHelper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/5/23.
//

import Foundation
import FirebaseFirestore
import Firebase

protocol FirebaseFirestoreService {
    func retrieveFriendsListener(user: UserObservable)
    func stopListening()
    func deleteItemFromArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?, String) -> Void)
    func addItemToArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?, String) -> Void)
    func searchForUserMatchingGames(collectionName: String, whereField: String, gameName: String) async throws -> [User]
//    func sendFriendRequest(newFriend: User, completion: @escaping (Error?, Friend) -> Void)
    func sendFriendRequest(newFriend: User) async throws -> Friend 
    func fetchMessages(fromId: String, toId: String, completion: @escaping (Error?, ChatMessage) -> Void)
    func handleSendMessage(toId: String, chatUserDisplayName: String, fromId: String, chatText: String) async throws
    func persistRecentMessage(toId: String, chatUserDisplayName: String, fromId: String, chatText: String) async throws
    func fetchRecentMessages(completion: @escaping (Error?, [RecentMessage]) -> Void)
    func createDualRecentMessage(toId: String, chatUserDisplayName: String, fromId: String) async throws
    func changeOnlineStatus(onlineStatus: Bool, toId: String, fromId: String) async throws 
    func saveUserReportToFirestore(userReport: UserReport) async
    
}

class FirebaseFirestoreHelper: NSObject, ObservableObject, FirebaseFirestoreService {
//    let user = UserObservable.shared
//    let firestoreDatabase = Firestore.firestore()
    let firestore: Firestore
    let user = UserObservable.shared
    let coreDataController = CoreDataController.shared
    private var listeningRegistration: ListenerRegistration?
//    let fbStorageHelper = FirebaseStorageHelper.shared
    
    static let shared = FirebaseFirestoreHelper()
    
    override init() {
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
    func retrieveFriendsListener(user: UserObservable) {
        listeningRegistration = firestore.collection(Constants.usersString).document(user.id).collection(Constants.userFriendList)
            .addSnapshotListener({ [weak self] snapshot, err in
                if let error = err {
                    print("ERROR GETTING FRIEND LIST DOCUMENTS: \(error.localizedDescription)")
                } else {
                    guard let self = self else { return }
                    guard let querySnapshot = snapshot else {
                        print("ERROR FETCHING SNAPSHOT DATA: ")
                        return
                    }
                    
                    let documents = querySnapshot.documents
                    //deletes all friends locally. this must be called before you get get new users.
                    for friend in coreDataController.savedFriendEntities {
                        self.coreDataController.deleteFriendLocally(friend: friend)
                    }
                    for document in documents {
                        let friendCodeID = document.data()[Constants.friendCodeID] as? String ?? "????"
                        let friendUserID = document.data()[Constants.friendUserID] as? String ?? ""
                        let friendDisplayName = document.data()[Constants.displayName] as? String ?? ""
                        let isFriend = document.data()[Constants.isFriend] as? Bool ?? false
                        let isFavorite = document.data()[Constants.isFavorite] as? Bool ?? false
                        let profileImageString = document.data()[Constants.imageString] as? String ?? ""
                        self.coreDataController.addFriend(friendCodeID: friendCodeID,
                                                          friendUserID: friendUserID,
                                                          friendDisplayName: friendDisplayName,
                                                          isFriend: isFriend,
                                                          isFavorite: isFavorite,
                                                          profileImageString: profileImageString)
                    }
                    //keep. use it so I can update the ui cleaner
//                    self.myFriendListData = querySnapshot.documents.compactMap({ document in
//                        try? document.data(as: Friend.self)
//                    })
                    
                }
            })
    }
    
    func stopListening() {
        listeningRegistration?.remove()
    }
    
    func deleteItemFromArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?, String) -> Void) {
        let documentRef = firestore.collection(collectionName).document(documentField)
        documentRef.updateData([
            arrayField: FieldValue.arrayRemove([itemName])
        ]) { error in
            if let error = error {
                print("ERROR REMOVING ITEM FROM ARRAY: \(error)")
            } else {
                completion(nil, itemName)
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
            }
        }
    }
    
    func searchForUserMatchingGames(collectionName: String, whereField: String, gameName: String) async throws -> [User] {
        let gameQuery = firestore.collection(collectionName).whereField(whereField, arrayContains: gameName)
//            let gameQuery = firesStoreDatabase.collection(Constants.users).whereField(Constants.userListOfGamesString, arrayContains: gameName)
        
        do {
            let snapshot = try await gameQuery.getDocuments()
            let users = snapshot.documents.map { document -> User in
                let data = document.data()
                let id = data[Constants.userID] as? String ?? ""
                let displayName = data[Constants.userDisplayName] as? String ?? ""
                let email = data[Constants.userEmail] as? String ?? ""
                let latitude = data[Constants.userLatitude] as? Double ?? 0.0
                let longitude = data[Constants.userLongitude] as? Double ?? 0.0
                let location = data[Constants.userLocation] as? String ?? ""
                let profileImageString = data[Constants.userProfileImageString] as? String ?? ""
                let friendCodeID = data[Constants.userFriendCodeID] as? String ?? ""
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
                            latitude: latitude,
                            longitude: longitude,
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
    
    // change to use codable and decodable.
    func sendFriendRequest(newFriend: User) async throws -> Friend {
        let friendListPath = firestore.collection(Constants.usersString).document(newFriend.id).collection(Constants.userFriendList).document(self.user.id)
        let yourInfoPath = self.firestore.collection(Constants.usersString).document(self.user.id).collection(Constants.userFriendList).document(newFriend.id)

        let yourFriendInfo = Friend(id: self.user.id,
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

        do {
            try await friendListPath.setData(yourFriendInfo.friendDictionary)
            try await yourInfoPath.setData(theirFriendInfo.friendDictionary)
            return theirFriendInfo
        } catch {
            throw error
        }
    }

    
    func createDualRecentMessage(toId: String, chatUserDisplayName: String, fromId: String) async throws {
        
        let recentSenderMessageData = [
            Constants.chatMessageTimeStamp: Timestamp(),
            Constants.chatMessageText: "",
            Constants.fromId: fromId,
            Constants.toId: toId,
            Constants.displayName: chatUserDisplayName,
            Constants.onlineStatus: true
//            "profileImageUrl":
            
        ] as [String : Any]
        
        let senderMessageDocumentPath = firestore
            .collection(Constants.recentMessages)
            .document(fromId)
            .collection(Constants.messagesStringCollectionCall)
            .document(toId)
        
        do {
            try await senderMessageDocumentPath.setData(recentSenderMessageData)
        } catch {
            print("ERROR, FAILED TO SAVE RECENT MESSAGES SENDER TO FIRESTORE: \(error.localizedDescription)")
            throw error
        }
        
        let recentReceiverMessageData = [
            Constants.chatMessageTimeStamp: Timestamp(),
            Constants.chatMessageText: "",
            Constants.fromId: toId,
            Constants.toId: fromId,
            Constants.displayName: user.displayName ?? "",
            Constants.onlineStatus: true
//            "profileImageUrl":
            
        ] as [String : Any]
        
        let receiverMessageDocumentPath = firestore
            .collection(Constants.recentMessages)
            .document(toId)
            .collection(Constants.messagesStringCollectionCall)
            .document(fromId)
        
        do {
            try await receiverMessageDocumentPath.setData(recentReceiverMessageData)
        } catch {
            print("ERROR, FAILED TO SAVE RECENT MESSAGES RECEIVER TO FIRESTORE: \(error.localizedDescription)")
            throw error
        }
        
    }
    
    func fetchMessages(fromId: String, toId: String, completion: @escaping (Error?, ChatMessage) -> Void) {
        let senderMessageDocumentPath = firestore
            .collection(Constants.messagesStringCollectionCall)
            .document(fromId)
            .collection(toId)
            .order(by: Constants.chatMessageTimeStamp)
        
        senderMessageDocumentPath.addSnapshotListener { querySnapshot, err in
            if let error = err {
                print("FAILED TO LISTEN FOR MESSAGES ERROR: \(error.localizedDescription)")
                return
            }
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let chatMessage = ChatMessage(documentId: change.document.documentID, data: data)
                    completion(nil, chatMessage)
                }
            })
            
        }
    }
    
    func handleSendMessage(toId: String, chatUserDisplayName: String, fromId: String, chatText: String) async throws {
        let senderMessageDocumentPath = firestore
            .collection(Constants.messagesStringCollectionCall)
            .document(fromId)
            .collection(toId)
            .document()
        let recipientMessageDocumentPath = firestore
            .collection(Constants.messagesStringCollectionCall)
            .document(toId)
            .collection(fromId)
            .document()
        
        let messageData = [Constants.fromId: fromId,
                           Constants.toId: toId,
                           Constants.chatMessageText: chatText,
                           Constants.chatMessageTimeStamp: Timestamp()] as [String : Any]
        
        do {
            try await senderMessageDocumentPath.setData(messageData)
        } catch {
            print("ERROR SETTING DATA IN THE MESSAGE CHAT LOG: \(error.localizedDescription)")
            throw error
        }
        
        do {
            try await recipientMessageDocumentPath.setData(messageData)
        } catch {
            print("ERROR SETTING DATA IN THE MESSAGE CHAT LOG: \(error.localizedDescription)")
            throw error
        }
    }

    func persistRecentMessage(toId: String, chatUserDisplayName: String, fromId: String, chatText: String) async throws {
        let uid = user.id
        let recentMessageDocumentPath = firestore.collection(Constants.recentMessages).document(uid).collection(Constants.messagesStringCollectionCall).document(toId)
        
        let recentMessageData = [
            Constants.chatMessageTimeStamp: Timestamp(),
            Constants.chatMessageText: chatText,
            Constants.fromId: uid,
            Constants.toId: toId,
            Constants.displayName: chatUserDisplayName
//            "profileImageUrl":
            
            // similar dictionary for the recipient of this message.
        ] as [String : Any]
        
        do {
            try await recentMessageDocumentPath.setData(recentMessageData)
        } catch {
            print("ERROR, FAILED TO SAVE RECENT MESSAGES TO FIRESTORE: \(error.localizedDescription)")
            throw error
        }
    }
    
    func changeOnlineStatus(onlineStatus: Bool, toId: String, fromId: String) async throws {
        let uid = user.id
        let recentMessageDocumentPath = firestore.collection(Constants.recentMessages).document(uid).collection(Constants.messagesStringCollectionCall).document(toId)
        
        let recentMessageData = [
            Constants.onlineStatus: onlineStatus
        ] as [String : Any]
        
        do {
            try await recentMessageDocumentPath.setData(recentMessageData)
        } catch {
            print("ERROR, FAILED TO SAVE RECENT MESSAGES TO FIRESTORE: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchRecentMessages(completion: @escaping (Error?, [RecentMessage]) -> Void) {
        let uid = user.id
        firestore
            .collection(Constants.recentMessages)
            .document(uid)
            .collection(Constants.messagesStringCollectionCall)
            .addSnapshotListener { querySnapshot, err in
            if let error = err {
                print("ERROR, FAILED TO LISTEN FOR RECENT MESSAGES: \(error.localizedDescription)")
                return
            }
            querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    var recentMessages: [RecentMessage] = []
                    recentMessages.append(.init(documentId: docId, data: change.document.data()))
                    completion(nil, recentMessages)
                    // ad to recent messages
            })
        }
    }

        func saveUserReportToFirestore(userReport: UserReport) async {
            do {
                let encoder = JSONEncoder()
                let reportData = try encoder.encode(userReport)
                
                let firestoreDocReference = firestore.collection(Constants.userReports).document(userReport.id)
                try firestoreDocReference.setData(from: reportData)
                
            } catch {
                print("Error encoding user report: \(error)")
            }
        }
    
}
