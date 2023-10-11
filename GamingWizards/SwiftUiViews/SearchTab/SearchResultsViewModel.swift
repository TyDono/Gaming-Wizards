//
//  SearchResultsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

//extension SearchResultsView {
     class SearchResultsViewModel: ObservableObject {
//        @Published var searchText: String = ""
        @ObservedObject var user = UserObservable.shared
        @Published var users: [User]? = []
        @Published var resultWasTapped: Bool = false
        @Published var selectedUser: User
        let fbFirestoreHelper: FirebaseFirestoreHelper
        let coreDataController: CoreDataController
        
        init(
            fbFirestoreHelper: FirebaseFirestoreHelper = .shared,
            coreDataController: CoreDataController = .shared,
            selectedUser: User = User(id: "110k1")
        ) {
            self.fbFirestoreHelper = fbFirestoreHelper
            self.coreDataController = coreDataController
            self._selectedUser = Published(initialValue: selectedUser)
        }
        
        func performSearchForUsers(searchText: String)  {
            Task {
                await performSearchForMatchingGames(gameName: searchText)
            }
        }
        
        func searchForMatchingUsers(gameName: String, isPayToPlay: Bool) async {
            Task {
                do {
                    let listOfUsers: [User]? = try await fbFirestoreHelper.fetchMatchingUsersSearch(gameName: gameName, isPayToPlay: isPayToPlay)
                    guard let safeListOfUsers = listOfUsers else { return }
                    for user in safeListOfUsers {
                        // Have a check if they are in your blocked user list here as well
                        if coreDataController.checkIfUserIsInFriendList(user: user) == false && user.id != self.user.id {
                            self.users?.append(user)
                        }
                    }
                } catch {
                    print("ERROR RETRIEVING MATCHING GAMES FROM SEARCH: \(error)")
                }
            }
        }
        
    }
//}
