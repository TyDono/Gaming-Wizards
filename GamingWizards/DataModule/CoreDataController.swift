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
import Combine

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
    }
    
    private func objectDidChange() {
        // Fetch your CoreData entity here or update it as needed
//        print("search settings changed")
//        print(savedSearchSettingsEntity)
//        print("pause")
//        let fetchRequest: NSFetchRequest<SearchSettingsEntity> = SearchSettingsEntity.fetchRequest()
//        
//        do {
//            self.savedSearchSettingsEntity = try CoreDataController.shared.context.fetch(fetchRequest).first
//        } catch {
//            // Handle the error
//            print("Error fetching CoreData entity: \(error)")
//        }
    }
    
    func clearAllData() async {
        await clearEntityData(entityName: "UserEntity")
        await clearEntityData(entityName: "FriendEntity")
        await clearEntityData(entityName: "BlockedUserEntity")
        await clearEntityData(entityName: "SearchSettingsEntity")
    }

    private func clearEntityData(entityName: String) async {
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
//        guard savedSearchSettingsEntity == nil else { return }
        let newSearchSettings = SearchSettingsEntity(context: viewContext)
        newSearchSettings.ageRangeMax = 18
        newSearchSettings.ageRangeMin = 18
        newSearchSettings.groupSizeRangeMax = 25
        newSearchSettings.groupSizeRangeMin = 0
        newSearchSettings.isPayToPlay = false
        newSearchSettings.searchRadius = 150
        
        do {
            try saveSearchSettingsToCoreData(searchSettings: newSearchSettings)
        } catch {
            print("ERROR SAVING SEARCH RADIUS TO SEARCH SETTINGS ENTITY: \(error)")
        }
    }
    
    func fetchSearchSettingsEntityPublisher() -> AnyPublisher<SearchSettingsEntity?, Error> {
        let fetchRequest: NSFetchRequest<SearchSettingsEntity> = SearchSettingsEntity.fetchRequest()
        return Future { promise in
            do {
                let settings = try self.viewContext.fetch(fetchRequest)
                promise(.success(settings.first))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
//    func fetchSavedSearchSettings() {
//        let fetchRequest: NSFetchRequest<SearchSettingsEntity> = SearchSettingsEntity.fetchRequest()
//        do {
//            let settings = try viewContext.fetch(fetchRequest)
//            savedSearchSettingsEntity = settings.first
//        } catch {
//            print("Failed to fetch saved SearchSettingsEntity: \(error)")
//        }
//    }
    
    func saveUserSearchSettingsToCoreData(_ searchSettings: SearchSettings) -> AnyPublisher<SearchSettingsEntity, Error> {
        return Future { promise in
            do {
                let context = self.viewContext
                var searchSettingsEntity: SearchSettingsEntity?
                // Check if there is an existing SearchSettingsEntity
                let fetchRequest: NSFetchRequest<SearchSettingsEntity> = SearchSettingsEntity.fetchRequest()
                if let existingSettings = try context.fetch(fetchRequest).first {
                    // Update the existing entity
                    searchSettingsEntity = existingSettings
                } else {
                    // Create a new entity if it doesn't exist
                    searchSettingsEntity = SearchSettingsEntity(context: context)
                }
                searchSettingsEntity?.ageRangeMax = Int16(searchSettings.ageRangeMax)
                searchSettingsEntity?.ageRangeMin = Int16(searchSettings.ageRangeMin)
                searchSettingsEntity?.groupSizeRangeMax = Int16(searchSettings.groupSizeRangeMax)
                searchSettingsEntity?.isPayToPlay = searchSettings.isPayToPlay
                searchSettingsEntity?.searchRadius = searchSettings.searchRadius
                
                // Save the context to persist the changes
                try context.save()
                
                if let entity = searchSettingsEntity {
                    promise(.success(entity))
                } else {
                    // Handle the case where the entity is not available
                    let error = NSError(domain: "YourDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to save SearchSettingsEntity"])
                    promise(.failure(error))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveSearchSettingsToCoreData(searchSettings: SearchSettingsEntity) throws {
        do {
            // Insert the search settings entity into the view context if it's not already there.
            if !viewContext.hasChanges {
                viewContext.insert(searchSettings)
            }
            
            try viewContext.save()
        } catch {
            print("ERROR SAVING SEARCH SETTINGS: \(error)")
        }
    }
    
//    func saveSearchSettingsToCoreData(searchSettings: SearchSettingsEntity) throws {
//        do {
//            try viewContext.save()
//            savedSearchSettingsEntity = searchSettings
//        } catch {
//            print("FAILED TO SAVED SEARCH SETTINGS: \(error)")
//            throw CoreDataError.saveError
//        }
//    }

    
    // MARK: FRIEND
    
    func fetchFriendEntitiesPublisher() -> AnyPublisher<[FriendEntity], Error> {
        let fetchRequest: NSFetchRequest<FriendEntity> = FriendEntity.fetchRequest()
        return Future { promise in
            do {
                let friends = try self.viewContext.fetch(fetchRequest)
                promise(.success(friends))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    //single value
//    func fetchSearchSettingsEntityPublisher() -> AnyPublisher<SearchSettingsEntity?, Error> {
//        let fetchRequest: NSFetchRequest<SearchSettingsEntity> = SearchSettingsEntity.fetchRequest()
//        return Future { promise in
//            do {
//                let settings = try self.viewContext.fetch(fetchRequest)
//                promise(.success(settings.first))
//            } catch {
//                promise(.failure(error))
//            }
//        }
//        .eraseToAnyPublisher()
//    }
    //create a func that can cover friend to entity and user to entity
    func convertToFriendEntity2(displayName: String?, friendUserID: String?, profileImageString: String?, isFavorite: Bool?, isFriend: Bool?, recentMessageText: String, recentMessageTimeStamp: Date, onlineStatus: Bool, messageToId: String) -> FriendEntity {
        let newFriendEntity = FriendEntity(context: viewContext)
//        newFriend.friendCodeID = friendCodeID
        newFriendEntity.id =  friendUserID
        newFriendEntity.displayName = displayName
        newFriendEntity.isFriend = isFriend ?? false
        newFriendEntity.isFavorite = isFavorite ?? false
        newFriendEntity.imageString = profileImageString
        newFriendEntity.recentMessageText = recentMessageText
        newFriendEntity.recentMessageTimeStamp = recentMessageTimeStamp
        newFriendEntity.onlineStatus = onlineStatus
        newFriendEntity.messageToId = messageToId
        
        return newFriendEntity
    }
    
//    func fetchFriends() {
//        viewContext.perform { [self] in
//            let request = NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
//            do {
//                savedFriendEntities = try viewContext.fetch(request)
//            } catch let error {
//                print("ERROR FETCHING CORE DATA: \(error)")
//            }
//        }
//    }
    
    //rename to convert then save
    func addFriend(friendUserID: String, friendDisplayName: String, isFriend: Bool, isFavorite: Bool, profileImageString: String) {
        let newFriend = FriendEntity(context: viewContext)
        newFriend.id =  friendUserID
        newFriend.displayName = friendDisplayName
        newFriend.isFriend = isFriend
        newFriend.isFavorite = isFavorite
        newFriend.imageString = profileImageString
        
        saveFriendToCoreData(friend: newFriend)
    }
    
    func deleteFriendInCloud(friend: FriendEntity, userId: String) { //later when you get help, move the deleting of you from their friend list to be the first action then from your own list, and then locally,
        guard let friendUserID = friend.id else { return }
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
                        }
                    }
                }
            }
    }
    
    func checkIfUserIsInFriendList(user: User, savedFriendEntities: [FriendEntity]) -> Bool {
        if savedFriendEntities.contains(where: { $0.id == user.id })  {
            return true
        } else {
            return false
        }
    }
    
    func deleteFriendLocally(friend: FriendEntity) {
        viewContext.perform { [self] in
            self.viewContext.delete(friend)
            do {
                try self.viewContext.save()
            } catch {
                print("ERROR SAVING CORE DATA: \(error)")
            }
        }
    }
    
    func saveFriendToCoreData(friend: FriendEntity) {
        do {
            if !viewContext.hasChanges {
                viewContext.insert(friend)
            }
            try viewContext.save()
        } catch {
            print("ERROR SAVING FRIEND CORE DATA: \(error)")
        }
    }
    
//    func saveFriendData() {
//        do {
//            try viewContext.save()
//            fetchFriends()
//        } catch let error {
//            print("ERROR SAVING CORE DATA \(error)")
//        }
//    }
    
    // MARK: Blocked Users
    
    func fetchBlockedUserEntitiesPublisher() -> AnyPublisher<[BlockedUserEntity], Error> {
        let fetchRequest: NSFetchRequest<BlockedUserEntity> = BlockedUserEntity.fetchRequest()
        return Future { promise in
            do {
                let blockedUsers = try self.viewContext.fetch(fetchRequest)
                promise(.success(blockedUsers))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
//    func fetchBlockedUser() {
//        viewContext.perform { [self] in
//            let request = NSFetchRequest<BlockedUserEntity>(entityName: "BlockedUserEntity")
//            do {
//                blockedUserEntities = try viewContext.fetch(request)
//            } catch let error {
//                print("ERROR FETCHING CORE DATA: \(error)")
//            }
//        }
//    }
    
    func saveBlockedUsersToCoreData(blockedUser: BlockedUserEntity) {
        do {
            // Insert the friend entity into the view context if it's not already there.
            if !viewContext.hasChanges {
                viewContext.insert(blockedUser)
            }
            
            try viewContext.save()
        } catch {
            print("ERROR SAVING BLOCKED USER CORE DATA: \(error)")
        }
    }
    
//    func saveBlockedUsers() {
//        do {
//            try viewContext.save()
//            fetchBlockedUser()
//        } catch {
//            print("ERROR SAVING CORE DATA \(error.localizedDescription)")
//        }
//    }
    
    func addBlockedUser(blockedUser: BlockedUser) {
        let newBlockedUser = BlockedUserEntity(context: viewContext)
        newBlockedUser.id = blockedUser.id
        newBlockedUser.displayName = blockedUser.displayName
        newBlockedUser.dateRemoved = blockedUser.dateRemoved
        
        saveBlockedUsersToCoreData(blockedUser: newBlockedUser)
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
                        }
                    }
                }
            }
    }
    
    func deleteBlockedUserLocally(blockedUser: BlockedUserEntity) {
        viewContext.perform { [self] in
            self.viewContext.delete(blockedUser)
            do {
                try self.viewContext.save()
            } catch {
                print("Error saving blocked user after deletion: \(error)")
            }
        }
    }
    
    // MARK: USER
    //not used in current MVP
    /*
    
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
     */
    
}
