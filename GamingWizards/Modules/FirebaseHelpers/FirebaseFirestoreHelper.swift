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
//    func sendFriendRequest(newFriend: User, completion: @escaping (Error?, Friend) -> Void)
    func sendFriendRequest(newFriend: User) async throws -> Friend 
    func fetchMessages(fromId: String, toId: String, completion: @escaping (Error?, ChatMessage) -> Void)
    func handleSendMessage(toId: String, chatUserDisplayName: String, fromId: String, chatText: String) async throws
    func persistRecentMessage(toId: String, chatUserDisplayName: String, fromId: String, chatText: String) async throws
    func fetchRecentMessages(completion: @escaping (Error?, [RecentMessage]) -> Void)
    func createDualRecentMessage(toId: String, chatUserDisplayName: String, fromId: String) async -> Result<Void, Error>
//    func createDualRecentMessage(toId: String, chatUserDisplayName: String, fromId: String) async throws
    func changeOnlineStatus(onlineStatus: Bool, toId: String, fromId: String) async throws 
    func saveUserReportToFirestore(userReport: UserReport) async throws
    func deleteRecentMessage(friend: FriendEntity, userId: String) async throws
    func deleteFriend(friend: FriendEntity, userId: String) async throws
    func blockUser(blockedUser: BlockedUser, friendEntity: FriendEntity) async throws
    func deleteBlockedUser(blockedUser: BlockedUserEntity) async throws
    func retrieveBlockedUsers(userId: String) async 
    func fetchMatchingUsersSearch(gameName: String?, isPayToPlay: Bool?) async throws -> [User]
    func updateUserDeviceInFirestore() async
    
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
                        let friendUserID = document.data()[Constants.friendUserID] as? String ?? ""
                        let friendDisplayName = document.data()[Constants.displayName] as? String ?? ""
                        let isFriend = document.data()[Constants.isFriend] as? Bool ?? false
                        let isFavorite = document.data()[Constants.isFavorite] as? Bool ?? false
                        let profileImageString = document.data()[Constants.imageString] as? String ?? ""
                        self.coreDataController.addFriend(friendUserID: friendUserID,
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
    
    func updateUserDeviceInFirestore() async {
        let deviceInfoResult = DeviceInfo.getDeviceInfo()
        do {
            let path = firestore.collection(Constants.usersString).document(user.id)
            let updateData: [String: Any] = [
                "deviceInfo": deviceInfoResult
            ]
            try await path.setData(updateData)
        } catch {
            print("UPDATING USER DEVICE IN CLOUD ERROR: \(error.localizedDescription)")
        }
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
    
    func fetchMatchingUsersSearch(gameName: String?, isPayToPlay: Bool?) async throws -> [User] {
        var query: Query = firestore.collection(Constants.usersString)
        
        if let gameName = gameName {
            query = query.whereField(Constants.userListOfGamesString, arrayContains: gameName)
        }
        
        if let isPayToPlay = isPayToPlay {
            query = query.whereField(Constants.userPayToPlay, isEqualTo: isPayToPlay)
        }
        
        do {
            let querySnapshot = try await query.getDocuments()
            let users = querySnapshot.documents.compactMap { document in
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
                
                return User(
                    id: id,
                    displayName: displayName,
                    email: email,
                    latitude: latitude,
                    longitude: longitude,
                    location: location,
                    profileImageString: profileImageString,
//                    friendCodeID: friendCodeID,
                    listOfGames: listOfGames,
                    groupSize: groupSize,
                    age: age,
                    about: about,
                    availability: availability,
                    title: title,
                    isPayToPlay: payToPlay,
                    isSolo: isSolo
                )
            }
            return users
        } catch {
            print("Error in Firestore query for user search: \(error)")
            throw error
        }
    }
    
    // change to use codable and decodable.
    func sendFriendRequest(newFriend: User) async throws -> Friend {
        let friendListPath = firestore.collection(Constants.usersString).document(newFriend.id).collection(Constants.userFriendList).document(self.user.id)
        let yourInfoPath = self.firestore.collection(Constants.usersString).document(self.user.id).collection(Constants.userFriendList).document(newFriend.id)

        let yourFriendInfo = Friend(id: self.user.id,
//                                    friendCodeID: self.user.friendCodeID,
                                    displayName: self.user.displayName ?? "",
                                    isFriend: false,
                                    isFavorite: false,
                                    imageString: self.user.profileImageString)

        let theirFriendInfo = Friend(id: newFriend.id,
//                                     friendCodeID: newFriend.friendCodeID,
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
    
    func createDualRecentMessage(toId: String, chatUserDisplayName: String, fromId: String) async -> Result<Void, Error> {
        
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
            return .failure(error)
        }
        
        let recentReceiverMessageData = [
            Constants.chatMessageTimeStamp: Timestamp(),
            Constants.chatMessageText: "",
            Constants.fromId: toId,
            Constants.toId: fromId,
            Constants.displayName: user.displayName ?? "",
            Constants.onlineStatus: true
    //        "profileImageUrl":
            
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
            return .failure(error)
        }
        
        return .success(())
    }

    
    func retrieveBlockedUsers(userId: String) async {
        let blockedUsersPath = firestore
            .collection(Constants.usersString)
            .document(userId)
            .collection(Constants.blockedUsers)

        do {
            let snapshot = try await blockedUsersPath.getDocuments()
            
            if let error = snapshot.documents.first?.metadata.isFromCache, error {
                print("Error fetching snapshot data: \(error)")
                return
            }

            let documents = snapshot.documents
            for blockedUser in await coreDataController.blockedUserEntities {
                await self.coreDataController.deleteBlockedUserLocally(blockedUser: blockedUser)
            }
            for document in documents {
                do {
                    let decoder = Firestore.Decoder()
                    let blockedUser = try decoder.decode(BlockedUser.self, from: document.data())
                    await self.coreDataController.addBlockedUser(blockedUser: blockedUser)
                } catch {
                    print("Error decoding document: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error getting friend list documents: \(error.localizedDescription)")
        }
    }
    
    func blockUser(blockedUser: BlockedUser, friendEntity: FriendEntity) async throws {
        let blockedUserData = blockedUser.blockedUserDictionary
        let blockedUserDocumentPath = firestore
            .collection(Constants.usersString)
            .document(user.id)
            .collection(Constants.blockedUsers)
            .document(blockedUser.id)
        do {
            try await blockedUserDocumentPath.setData(blockedUserData)
            await coreDataController.addBlockedUser(blockedUser: blockedUser)
            await coreDataController.deleteFriendInCloud(friend: friendEntity, userId: user.id)
            try await deleteRecentMessage(friend: friendEntity, userId: user.id)
        } catch {
            print("ERROR BLOCKING USER FROM FIRESTORE: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteBlockedUser(blockedUser: BlockedUserEntity) async throws {
        let blockedUserDocumentPath = firestore
            .collection(Constants.usersString)
            .document(user.id)
            .collection(Constants.blockedUsers)
            .document(blockedUser.id!)
        do {
            try await blockedUserDocumentPath.delete()
            await coreDataController.deleteBlockedUserLocally(blockedUser: blockedUser)
        } catch {
            print("ERROR DELETING BLOCKED USER FROM FIRESTORE: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteRecentMessage(friend: FriendEntity, userId: String) async throws {
        guard let friendUserId = friend.id else { return }
        let friendDocPath = firestore.collection(Constants.recentMessages)
            .document(friendUserId)
            .collection(Constants.messagesStringCollectionCall)
            .document(userId)
        let userFriendDocPath = firestore.collection(Constants.recentMessages)
            .document(userId)
            .collection(Constants.messagesStringCollectionCall)
            .document(friendUserId)
        do {
            try await friendDocPath.delete()
            try await userFriendDocPath.delete()
        } catch {
            print("ERROR DELETING RECENT MESSAGE FROM FIRESTORE: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteFriend(friend: FriendEntity, userId: String) async throws {
        guard let friendUserId = friend.id else { return }
        // Delete your yourself from their friend's list
        let friendDocPath = firestore.collection(Constants.usersString)
            .document(friendUserId)
            .collection(Constants.userFriendList)
            .document(userId)
        // Delete the friend from the user's friend list
        let userFriendDocPath = firestore.collection(Constants.usersString)
            .document(userId)
            .collection(Constants.userFriendList)
            .document(friendUserId)
        do {
            try await friendDocPath.delete()
            try await userFriendDocPath.delete()
            
            // Delete the friend from CoreData
            await coreDataController.viewContext.delete(friend)
            await coreDataController.saveFriendData()
            
        } catch {
            print("ERROR DELETING FRIEND FROM FIRESTORE: \(error.localizedDescription)")
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

        func saveUserReportToFirestore(userReport: UserReport) async throws {
            let firestoreDocReference = firestore.collection(Constants.userReports).document(userReport.id)
            do {
//                let encoder = JSONEncoder()
//                let reportData = try encoder.encode(userReport)
                
                try firestoreDocReference.setData(from: userReport)
                
            } catch {
                print("Error encoding user report: \(error)")
            }
        }
    
}
