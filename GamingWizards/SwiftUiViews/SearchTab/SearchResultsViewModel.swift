//
//  SearchResultsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI
import Combine

//extension SearchResultsView {
class SearchResultsViewModel: ObservableObject {
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
    
    func cancelFriendEntities() {
        friendEntitiesCancellable?.cancel()
    }
    
    func cancelSearchSettings() {
        searchSettingsCancellable?.cancel()
    }
    
    func cancelBlockedUserEntities() {
        blockedUserEntitiesCancellable?.cancel()
    }
    
    func callForCoreDatsEntities() async {
        await withCheckedContinuation { continuation in
            // Fetch friends
            self.friendEntitiesCancellable = coreDataController.fetchFriendEntitiesPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }) { friends in
                    if !friends.isEmpty {
                        self.savedFriendEntities = friends
                    }
                }
            
            // Fetch search settings
            self.searchSettingsCancellable = coreDataController.fetchSearchSettingsEntityPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }) { searchSettings in
                    if searchSettings != nil {
                        self.savedSearchSettingsEntity = searchSettings
                    }
                    // Once search settings are fetched, trigger the continuation
                    continuation.resume()
                }
            
            // Fetch blocked users
            self.blockedUserEntitiesCancellable = coreDataController.fetchBlockedUserEntitiesPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }) { blockedUsers in
                    if !blockedUsers.isEmpty {
                        self.savedBlockedUserEntities = blockedUsers
                    }
                }
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
                                        messageToId: String) -> Binding<Friend> {
        
        // Create a Friend object from the user info
        var friend = Friend(
            id: friendUserID,
            displayName: displayName,
            isFriend: isFriend,
            isFavorite: isFavorite,
            imageString: profileImageString,
            recentMessageText: recentMessageText,
            recentMessageTimeStamp: recentMessageTimeStamp,
            onlineStatus: onlineStatus,
            messageToId: messageToId
        )
        
        // Create and return a Binding<Friend>
        return Binding(get: {
            friend
        }, set: { newValue in
            // Update the friend properties when the binding is set
            friend.id = newValue.id
            friend.displayName = newValue.displayName
            friend.isFriend = newValue.isFriend
            friend.isFavorite = newValue.isFavorite
            friend.imageString = newValue.imageString
            friend.recentMessageText = newValue.recentMessageText
            friend.recentMessageTimeStamp = newValue.recentMessageTimeStamp
            friend.onlineStatus = newValue.onlineStatus
            friend.messageToId = newValue.messageToId
        })
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
