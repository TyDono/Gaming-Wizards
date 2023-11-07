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
    func stopListening()
    func deleteItemFromArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?, String) -> Void)
    func addItemToArray(collectionName: String, documentField: String, itemName: String, arrayField: String, completion: @escaping (Error?, String) -> Void)
//    func sendFriendRequest(newFriend: User) async throws -> Friend 
    func sendFriendRequest(senderFriendInfo: Friend, receiverFriendInfo: Friend) async -> Result<Friend, Error>
    func fetchListOfFriends(uid: String, completion: @escaping (Error?, [Friend]) -> Void)
    func fetchMessages(fromId: String, toId: String, completion: @escaping (Error?, ChatMessage) -> Void)
    func handleSendMessage(toId: String, chatUserDisplayName: String, fromId: String, chatText: String) async throws
    func changeOnlineStatus(onlineStatus: Bool, toId: String, fromId: String) async throws 
    func saveUserReportToFirestore(userReport: UserReport) async throws
    func deleteFriend(friend: FriendEntity, userId: String) async throws
    func blockUser(blockedUser: BlockedUser, friendEntity: FriendEntity) async throws
    func deleteBlockedUser(blockedUser: BlockedUserEntity) async throws
    func retrieveBlockedUsers(userId: String) async
    func fetchMatchingUsersSearch(gameName: String?, isPayToPlay: Bool?, friendUserIDs: [FriendEntity]?, blockedUserIds: [BlockedUserEntity]?) async throws -> [User]
    func updateUserDeviceInFirestore() async
//    func saveUserSearchSettings(userId: String, searchSettings: SearchSettings) async -> Result<Bool, Error> 
    func saveChangesToFirestore<T: Updatable, U: Updatable>(from oldData: T, to newData: U, userId: String) async -> Result<Void, Error>
    func fetchUserSearchSettings(userId: String) async -> SearchSettings? 
    
}

class FirebaseFirestoreHelper: NSObject, ObservableObject, FirebaseFirestoreService {
    let firestore: Firestore
    let user = UserObservable.shared
    let coreDataController = CoreDataController.shared
    private var listeningRegistration: ListenerRegistration?
    private var listeningFriendRegistration: ListenerRegistration?
    
    static let shared = FirebaseFirestoreHelper()
    
    override init() {
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
    /*
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
     */
    
    func updateUserDeviceInFirestore() async {
        let deviceInfoResult = DeviceInfo.getDeviceInfo()
        
        do {
            let path = firestore.collection(Constants.usersString).document(user.id)
            try await path.updateData(["deviceInfo": deviceInfoResult])
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
    
    func fetchMatchingUsersSearch(gameName: String?, isPayToPlay: Bool?, friendUserIDs: [FriendEntity]?, blockedUserIds: [BlockedUserEntity]?) async throws -> [User] {
        
        var query: Query = firestore.collection(Constants.usersString)
        if let gameName = gameName {
            query = query.whereField(Constants.userListOfGamesString, arrayContains: gameName)
        }
        if let isPayToPlay = isPayToPlay {
            query = query.whereField(Constants.userPayToPlay, isEqualTo: isPayToPlay)
        }
        query = query.whereField(Constants.idStringValue, isNotEqualTo: user.id)
        
        do {
            let querySnapshot = try await query.getDocuments()
            let users = try querySnapshot.documents.compactMap { document in
                let data = document.data()
                let decoder = Firestore.Decoder()
                return try decoder.decode(User.self, from: data)
            }

            if let friendUserIDs = friendUserIDs {
                let processedFriendIds = DataProcessor.extractUserIDs(from: friendUserIDs)
                let blockedUserIds = blockedUserIds ?? []
                let processedBlockedUserIds = DataProcessor.extractUserIDsFromBlockedUser(from: blockedUserIds)
                let filteredUsers = users.filter { user in
                    return !processedFriendIds.contains(user.id) && !processedBlockedUserIds.contains(user.id)
                }
                return filteredUsers
            }

            return users

        } catch {
            print("Error in Firestore query for user search: \(error)")
            throw error
        }
    }
    
    func sendFriendRequest(senderFriendInfo: Friend, receiverFriendInfo: Friend) async -> Result<Friend, Error> {
        do {
            let senderFriendPath = firestore.collection(Constants.userFriendList).document(receiverFriendInfo.id).collection(Constants.listOfFriends).document(senderFriendInfo.id)
            let receiverFriendPath = firestore.collection(Constants.userFriendList).document(senderFriendInfo.id).collection(Constants.listOfFriends).document(receiverFriendInfo.id)
            
            try await senderFriendPath.setData(senderFriendInfo.friendDictionary)
            try await receiverFriendPath.setData(receiverFriendInfo.friendDictionary)
            
            return .success(receiverFriendInfo)
        } catch {
            print("SEND FRIEND REQUEST TO FIRE STORE CLOUD ERROR: \(error.localizedDescription)")
            return .failure(error)
        }
    }
    
    func fetchListOfFriends(uid: String, completion: @escaping (Error?, [Friend]) -> Void) {
        firestore
            .collection(Constants.userFriendList)
            .document(uid)
            .collection(Constants.listOfFriends)
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print("ERROR, FAILED TO LISTEN FOR RECENT MESSAGES: \(error.localizedDescription)")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    var listOfFriends: [Friend] = []
                    listOfFriends.append(.init(data: change.document.data()))
                    completion(nil, listOfFriends)
                })
            }
    }
    
    func stopListeningToFriendRegistration() {
        listeningFriendRegistration?.remove()
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
            // below commented out code not needed as i delete all core data when the user logs out. this is only called when the user logs in with a pre-existing account
//            for blockedUser in await coreDataController.blockedUserEntities {
//                await self.coreDataController.deleteBlockedUserLocally(blockedUser: blockedUser)
//            }
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
            try await deleteFriend(friend: friendEntity, userId: user.id)
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
    
    // MARK: Search Settings
    
    /*
    func saveUserSearchSettings(userId: String, searchSettings: SearchSettings) async -> Result<Bool, Error> {
        
        do {
            let searchSettingsPath = firestore.collection(Constants.searchSettings).document(userId)
            let encoder = JSONEncoder()
            let searchSettingsData = try encoder.encode(searchSettings)
            
            try await searchSettingsPath.setData([Constants.searchSettings: searchSettingsData])
            
            return .success(true)
        } catch {
            print("Error updating Firestore document: \(error)")
            return .failure(error)
        }
    }
    */
    
    func saveChangesToFirestore<T: Updatable, U: Updatable>(from oldData: T, to newData: U, userId: String) async -> Result<Void, Error> {
        let changes = ChangeMapper.mapChanges(from: oldData, to: newData)
        if changes.isEmpty {
            return .success(())
        }
        do {
            let firestore = Firestore.firestore()
            let documentReference = firestore.collection(Constants.searchSettings).document(userId)
            let documentSnapshot = try await documentReference.getDocument()
            if documentSnapshot.exists {
                try await documentReference.updateData(changes)
            } else {
                try await documentReference.setData(changes)
            }
            return .success(())
        } catch let error {
            return .failure(FirestoreError.updateFailed(error.localizedDescription))
        }
    }
    
    func fetchUserSearchSettings(userId: String) async -> SearchSettings? {
        let searchSettingPath = firestore.collection(Constants.searchSettings).document(userId)
        do {
            let document = try await searchSettingPath.getDocument()
            if document.exists == true, let documentData = document.data() {
                do {
                    let decoder = Firestore.Decoder()
                    let existingSearchSettings = try decoder.decode(SearchSettings.self, from: documentData)
                    return existingSearchSettings
                } catch {
                    print("ERROR DECODING SEARCH SETTINGS: \(error.localizedDescription)")
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            print("ERROR FETCHING SEARCH SETTINGS: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteUserFirebaseAccount(userId: String) async {
        let path = firestore.collection(Constants.usersString).document(userId)
        await path.delete() { err in
            if let error = err {
                print("FIRESTORE DELETION ERROR: \(error.localizedDescription)")
            } else {
                // have user be logged out
            }
        }
    }
    
}
