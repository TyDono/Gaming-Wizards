//
//  SearchResultsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI
import Combine

//extension SearchResultsView {
     @MainActor class SearchResultsViewModel: ObservableObject {
//        @Published var searchText: String = ""
         @ObservedObject var user = UserObservable.shared
         @Published var searchedForUsers: [User]? = []
         @Published var resultWasTapped: Bool = false
         @Published var selectedUser: User
         @Published var isCreateReportUserViewShowing: Bool = false
         let fbFirestoreService: FirebaseFirestoreService
         let coreDataController: CoreDataController
         @Published var savedFriendEntities: [FriendEntity]?
         @Published var savedSearchSettingsEntity: SearchSettingsEntity?
         @Published var savedBlockedUserEntities: [BlockedUserEntity]?
         private var friendEntitiesCancellable: AnyCancellable?
         private var searchSettingsCancellable: AnyCancellable?
         private var blockedUserEntitiesCancellable: AnyCancellable?
         
         init(
            fbFirestoreHelper: FirebaseFirestoreService = FirebaseFirestoreHelper.shared,
            coreDataController: CoreDataController = .shared,
            selectedUser: User = User(id: "110k1")
        ) {
            self.fbFirestoreService = fbFirestoreHelper
            self.coreDataController = coreDataController
            self._selectedUser = Published(initialValue: selectedUser)

        }
         
         func callForCoreDatsEntities() async {
             self.friendEntitiesCancellable = coreDataController.fetchFriendEntitiesPublisher()
                 .receive(on: DispatchQueue.main)
                 .sink(receiveCompletion: { _ in }) { friends in
                     if !friends.isEmpty {
                         self.savedFriendEntities = friends
                     }
                     print(friends)
                     print("pause1")
                 }
             self.searchSettingsCancellable = coreDataController.fetchSearchSettingsEntityPublisher()
                 .receive(on: DispatchQueue.main)
                 .sink(receiveCompletion: { _ in }) { searchSettings in
                     if searchSettings != nil {
                         self.savedSearchSettingsEntity = searchSettings
                     }
                     print(searchSettings)
                     print("pause2")
                 }
             self.blockedUserEntitiesCancellable = coreDataController.fetchBlockedUserEntitiesPublisher()
                 .receive(on: DispatchQueue.main)
                 .sink(receiveCompletion: { _ in }) { blockedUsers in
                     if !blockedUsers.isEmpty {
                         self.savedBlockedUserEntities = blockedUsers
                     }
                     print(blockedUsers)
                     print("pause3")
                 }
         }
         
         
         func convertUserToFriendDataBinding(displayName: String,
                                             friendUserID: String,
                                             profileImageString: String,
                                             isFavorite: Bool,
                                             isFriend: Bool,
                                             recentMessageText: String,
                                             recentMessageTimeStamp: Date,
                                             onlineStatus: Bool,
                                             messageToId: String) -> Binding<FriendEntity> {
             let friendEntity: FriendEntity = coreDataController.convertToFriendEntity2(
                 displayName: displayName,
                 friendUserID: friendUserID,
                 profileImageString: profileImageString,
                 isFavorite: isFavorite,
                 isFriend: isFriend,
                 recentMessageText: recentMessageText,
                 recentMessageTimeStamp: recentMessageTimeStamp,
                 onlineStatus: onlineStatus,
                 messageToId: messageToId
             )
             // Create a Binding for the FriendEntity
             let binding = Binding(get: {
                 friendEntity
             }, set: { newValue in
                 // Update properties of friendEntity when the binding is set
     //            friendEntity.friendCodeID = newValue.friendCodeID
                 friendEntity.id = newValue.id
                 friendEntity.displayName = newValue.displayName
                 friendEntity.isFriend = newValue.isFriend
                 friendEntity.isFavorite = newValue.isFavorite
                 friendEntity.imageString = newValue.imageString
             })
             return binding
         }
        
        func searchForMatchingUsers(gameName: String, isPayToPlay: Bool) async {
            Task {
                do {
                    let listOfUsers: [User]? = try await fbFirestoreService.fetchMatchingUsersSearch(gameName: gameName, isPayToPlay: isPayToPlay, friendUserIDs: savedFriendEntities, blockedUserIds: savedBlockedUserEntities)
                    guard let safeListOfUsers = listOfUsers else { return }
                    for user in safeListOfUsers {
                        self.searchedForUsers?.append(user)
                    }
                } catch {
                    print("ERROR RETRIEVING MATCHING GAMES FROM SEARCH: \(error)")
                }
            }
        }
        
    }
//}
