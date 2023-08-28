//
//  SearchResultsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

extension SearchResultsView {
    @MainActor class SearchResultsViewModel: ObservableObject {
        @Published var searchText: String = ""
        @Published var users: [User]? = []
        let fbFirestoreHelper: FirebaseFirestoreHelper
        let coreDataController: CoreDataController
        
        init(
            fbFirestoreHelper: FirebaseFirestoreHelper = .shared,
            coreDataController: CoreDataController = .shared
        ) {
            self.fbFirestoreHelper = fbFirestoreHelper
            self.coreDataController = coreDataController
        }
        
        func performSearchForMatchingGames(gameName: String) async {
            Task {
                do {
                    let listOfUsers: [User]? = try await fbFirestoreHelper.searchForUserMatchingGames(collectionName: Constants.usersString, whereField: Constants.userListOfGamesString, gameName: gameName)
                    guard let safeListOfUsers = listOfUsers else { return }
                    for user in safeListOfUsers {
                        // Have a check if they are in your blocked user list here as well
                        if coreDataController.checkIfUserIsInFriendList(user: user) == false {
                            self.users?.append(user)
                        }
                    }
                } catch {
                    print("ERROR RETRIEVING MATCHING GAMES FROM SEARCH: \(error)")
                }
            }
        }
        
    }
}
