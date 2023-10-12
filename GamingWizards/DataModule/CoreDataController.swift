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
    let diskSpaceHandler = DiskSpaceHandler()
    let fbFirestoreHelper = Firestore.firestore()
    let fbStorageHelper = Storage.storage()
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    @Published var savedUserEntities: [UserEntity] = []
    @Published var savedFriendEntities: [FriendEntity] = []
    @Published var blockedUserEntities: [BlockedUserEntity] = []
    @Published var savedSearchSettingsEntity: SearchSettingsEntity?
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
        fetchBlockedUser()
        fetchSavedSearchSettings()
        //have fetch user here later if ever added
    }
    
    func clearAllData() {
        clearEntityData(entityName: "UserEntity")
        clearEntityData(entityName: "FriendEntity")
        clearEntityData(entityName: "BlockedUserEntity")
        clearEntityData(entityName: "SearchSettingsEntity")
    }

    private func clearEntityData(entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
            print("Cleared Core Data for entity \(entityName)")
        } catch {
            print("Failed to clear Core Data for entity \(entityName): \(error)")
        }
    }
    
    enum CoreDataError: Error {
        case saveError
        // Add more cases as needed
    }
    
    // MARK: SearchSettings
    
    func createBaselineSearchSettings() {
        guard savedSearchSettingsEntity == nil else { return }
        let newSearchSettings = SearchSettingsEntity(context: viewContext)
        newSearchSettings.ageRangeMax = 18
        newSearchSettings.ageRangeMin = 18
        newSearchSettings.groupSizeRangeMax = 0
        newSearchSettings.groupSizeRangeMin = 25
        newSearchSettings.isFreeToPlay = true
        newSearchSettings.searchRadius = 150
        
        do {
            try saveSearchSettings(searchSettings: newSearchSettings)
        } catch {
            print("ERROR SAVING SEARCH RADIUS TO SEARCH SETTINGS ENTITY: \(error)")
        }
    }
    
    func fetchSavedSearchSettings() {
        let fetchRequest: NSFetchRequest<SearchSettingsEntity> = SearchSettingsEntity.fetchRequest()
        do {
            let settings = try viewContext.fetch(fetchRequest)
            savedSearchSettingsEntity = settings.first
        } catch {
            print("Failed to fetch saved SearchSettingsEntity: \(error)")
        }
    }
    
    func saveSearchSettings(searchSettings: SearchSettingsEntity) throws {
        do {
            try viewContext.save()
            savedSearchSettingsEntity = searchSettings
        } catch {
            print("FAILED TO SAVED SEARCH SETTINGS: \(error)")
            throw CoreDataError.saveError
        }
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
    
    func addFriend(friendUserID: String, friendDisplayName: String, isFriend: Bool, isFavorite: Bool, profileImageString: String) { // change this to patch friend entity
        let newFriend = FriendEntity(context: viewContext)
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
    
    func fetchBlockedUser() {
        viewContext.perform { [self] in
            let request = NSFetchRequest<BlockedUserEntity>(entityName: "BlockedUserEntity")
            do {
                blockedUserEntities = try viewContext.fetch(request)
            } catch let error {
                print("ERROR FETCHING CORE DATA: \(error)")
            }
        }
    }
    
    func fetchFriengds() {
        viewContext.perform { [self] in
            let request = NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
            do {
                savedFriendEntities = try viewContext.fetch(request)
            } catch let error {
                print("ERROR FETCHING CORE DATA: \(error)")
            }
        }
    }
    
    func saveBlockedUsers() {
        do {
            try viewContext.save()
            fetchBlockedUser()
        } catch {
            print("ERROR SAVING CORE DATA \(error.localizedDescription)")
        }
    }
    
    func addBlockedUser(blockedUser: BlockedUser) {
        let newBlockedUser = BlockedUserEntity(context: viewContext)
        newBlockedUser.id = blockedUser.id
        newBlockedUser.displayName = blockedUser.displayName
        newBlockedUser.dateRemoved = blockedUser.dateRemoved
        
        saveBlockedUsers()
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
        } catch {
            print("ERROR FETCHING CORE DATA: \(error.localizedDescription)")
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
