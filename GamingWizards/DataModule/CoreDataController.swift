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

class CoreDataController: ObservableObject {
    
    static let shared = CoreDataController()
//    @ObservedObject var user = UserObservable()
    @ObservedObject var user = UserObservable.shared
//    @AppStorage(Constants.appStorageStringUserFriendCodeID) var user_Id: String?
//    @AppStorage(Constants.appStorageStringUserFriendCodeID) var user_Friend_Code_ID: String?
    let firestoreDatabase = Firestore.firestore()
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    @Published var savedUserEntities: [UserEntity] = []
    @Published var savedFriendEntities: [FriendEntity] = []
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
    
    func fetchFriends() {
        let request = NSFetchRequest<FriendEntity>(entityName: "FriendEntity")
        
        do {
            savedFriendEntities = try viewContext.fetch(request)
        } catch let error {
            print("ERROR FETCHING CORE DATA: \(error)")
        }
    }
    
    func addFriend(friendCodeID: String, friendUserID: String, friendDisplayName: String, isFriend: Bool, isFavorite: Bool) { // change this to patch friend entity
        let newFriend = FriendEntity(context: viewContext)
        newFriend.friendCodeID = friendCodeID
        newFriend.friendUserID =  friendUserID
        newFriend.friendDisplayName = friendDisplayName
        newFriend.isFriend = isFriend
        newFriend.isFavorite = isFavorite
        saveFriendData()
    }
    
    //not needed. remove. outdated
    func deleteFriend(friend: FriendEntity, userID: String) { //later when you get help, move the deleting of you from their friend list to be the first action then from your own list, and then locally,
//        guard let userFriendCodeID = user.friendCodeID else { return }
        guard let friendUserID = friend.friendUserID else { return }
        guard let friendCodeID = friend.friendCodeID else { return }
        firestoreDatabase.collection(Constants.usersString).document(friendUserID).collection(Constants.userFriendList).document(user.friendCodeID )
            .delete() { err in
                if let error = err {
                    print("ERROR DELETING YOURSELF FROM YOUR FRIEND'S FRIEND LIST: \(error.localizedDescription)")
                } else {
                    self.firestoreDatabase.collection(Constants.usersString).document(userID).collection(Constants.userFriendList).document(friendCodeID).delete() { err in
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
    
    func deleteFriendLocally(friend: FriendEntity) {
        self.viewContext.delete(friend)
        self.saveFriendData()
    }
    
    func saveFriendData() {
        do {
            try viewContext.save()
            fetchFriends()
        } catch let error {
            print("ERROR SAVING CORE DATA \(error)")
        }
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
