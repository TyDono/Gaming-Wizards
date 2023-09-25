//
//  CoreDataController.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/14/22.
//

import CoreData
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class CoreDataController: ObservableObject {
    
    static let shared = CoreDataController()
//    @ObservedObject var user = UserObservable()
    @ObservedObject var user = UserObservable.shared
//    @AppStorage(Constants.appStorageStringUserFriendCodeID) var user_Id: String?
//    @AppStorage(Constants.appStorageStringUserFriendCodeID) var user_Friend_Code_ID: String?
//    let firestoreDatabase = Firestore.firestore()
    let diskSpaceHandler = DiskSpaceHandler()
//    let fbFirestoreHelper = FirebaseFirestoreHelper.shared
//    var fbStorageHelper2 = FirebaseFirestoreHelper.shared
//    var fbFirestoreService: FirebaseFirestoreService
    let fbFirestoreHelper = Firestore.firestore()
    let fbStorageHelper = Storage.storage()
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    @Published var savedUserEntities: [UserEntity] = []
    @Published var savedFriendEntities: [FriendEntity] = []
    @Published var blockedUserEntities: [BlockedUserEntity] = []
    @Published var savedUser: UserEntity?
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "GamingWizardsContainer")
        persistentContainer.loadPersistentStores { description, err in
            if let error = err {
                print("ERROR LOADING CORE DATA: \(error.localizedDescription)")
                return
            }
            self.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
        fetchFriends()
        //have fetch user here later if ever added
    }
    
    // MARK: FRIEND
    
    func clearAllFriends() { // post MVP
        for friend in savedFriendEntities {
            self.deleteFriendLocally(friend: friend)
        }
    }
    
    func fetchFriends() {
        viewContext.perform { [self] in
            let request = NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
            do {
                savedFriendEntities = try viewContext.fetch(request)
            } catch let error {
                print("ERROR FETCHING CORE DATA: \(error)")
            }
        }
    }
    
    func addFriend(friendCodeID: String, friendUserID: String, friendDisplayName: String, isFriend: Bool, isFavorite: Bool, profileImageString: String) { // change this to patch friend entity
        let newFriend = FriendEntity(context: viewContext)
        newFriend.friendCodeID = friendCodeID
        newFriend.id =  friendUserID
        newFriend.displayName = friendDisplayName
        newFriend.isFriend = isFriend
        newFriend.isFavorite = isFavorite
        newFriend.imageString = profileImageString
        
        saveFriendData()
    }
    
    func deleteFriendInCloud(friend: FriendEntity, userId: String) { //later when you get help, move the deleting of you from their friend list to be the first action then from your own list, and then locally,
//        guard let userFriendCodeID = user.friendCodeID else { return }
        guard let friendUserID = friend.id else { return }
//        guard let friendCodeID = friend.friendCodeID else { return }
        fbFirestoreHelper.collection(Constants.usersString).document(friendUserID).collection(Constants.userFriendList).document(userId)
            .delete() { err in
                if let error = err {
                    print("ERROR DELETING YOURSELF FROM YOUR FRIEND'S FRIEND LIST: \(error.localizedDescription)")
                } else {
                    self.fbFirestoreHelper.collection(Constants.usersString).document(userId).collection(Constants.userFriendList).document(friendUserID).delete() { err in
                        if let error = err {
                            print("ERROR DELETING SPECIFIC FRIEND IN THE FIRESTORE CLOUD: \(error.localizedDescription)")
                        } else {
                            self.viewContext.delete(friend)
                            self.saveFriendData()
                        }
                    }
                }
            }
    }
    
    func checkIfUserIsInFriendList(user: User) -> Bool {
        if savedFriendEntities.contains(where: { $0.id == user.id })  {
            return true
        } else {
            return false
        }
    }
    
    func deleteFriendLocally(friend: FriendEntity) {
        viewContext.perform { [self] in
            self.viewContext.delete(friend)
            self.saveFriendData()
        }
    }
    
    func saveFriendData() {
        do {
            try viewContext.save()
            fetchFriends()
        } catch let error {
            print("ERROR SAVING CORE DATA \(error)")
        }
    }
    
    // MARK: Blocked Users
    
    func blockUser() { //adds them your list of blocked
        
    }
    
    func fetchBlockedUser() {
        viewContext.perform { [self] in
            let request = NSFetchRequest<BlockedUserEntity>(entityName: "BlockedUserEntities")
            do {
                blockedUserEntities = try viewContext.fetch(request)
            } catch let error {
                print("ERROR FETCHING CORE DATA: \(error)")
            }
        }
    }
    
    func saveBlockedUsers() {
        do {
            try viewContext.save()
            fetchBlockedUser()
        } catch let error {
            print("ERROR SAVING CORE DATA \(error)")
        }
    }
    
    func deleteBlockedUserInCloud(blockedUser: BlockedUserEntity, userId: String) {
        guard let blockedUserId = blockedUser.id else { return }
        //        guard let friendCodeID = blockedUser.friendCodeID else { return }
        
        fbFirestoreHelper.collection(Constants.usersString).document(blockedUserId).collection(Constants.blockedUsers).document(userId )
            .delete() { err in
                if let error = err {
                    print("ERROR DELETING YOURSELF FROM YOUR FRIEND'S FRIEND LIST: \(error.localizedDescription)")
                } else {
                    self.fbFirestoreHelper.collection(Constants.usersString).document(userId).collection(Constants.userFriendList).document(blockedUserId).delete() { err in
                        if let error = err {
                            print("ERROR DELETING SPECIFIC FRIEND IN THE FIRESTORE CLOUD: \(error.localizedDescription)")
                        } else {
                            self.viewContext.delete(blockedUser)
                            self.saveBlockedUsers()
                        }
                    }
                }
            }
    }
    
    func deleteBlockedUserLocally(blockedUser: BlockedUserEntity) {
        viewContext.perform { [self] in
            self.viewContext.delete(blockedUser)
            self.saveBlockedUsers()
        }
    }
    
    func addBlockedUser(id: String, displayName: String, dateRemoved: Date) {
        let newBlockedUser = BlockedUserEntity(context: viewContext)
        newBlockedUser.id = id
        newBlockedUser.displayName = displayName
        newBlockedUser.dateRemoved = dateRemoved
        
        saveBlockedUsers()
    }
    
    // MARK: USER
    //not used in current MVP
    
    func fetchUser() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        
        do {
            savedUserEntities = try viewContext.fetch(request)
        } catch let error {
            print("ERROR FETCHING CORE DATA: \(error)")
        }
    }
    
    func addUser(text: String) {
        let newUser = UserEntity(context: viewContext)
        newUser.displayName = text
//        saveUserData()
    }
    
    func updateUserDisplayName(entity: UserEntity) {
        let newUserDisplayName = UserEntity(context: viewContext)
//        newUserDisplayName.displayName = text
//        let newDisplayName =
//        saveUserData()
    }
    
}
