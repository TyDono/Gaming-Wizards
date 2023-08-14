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
        let firebaseHelper = FirebaseFirestoreHelper.shared
        let coreDataController = CoreDataController.shared
        
        func performSearchForMatchingGames(gameName: String) async {
            Task {
                do {
                    let listOfUsers: [User]? = try await firebaseHelper.searchForMatchingGames(collectionName: Constants.usersString, whereField: Constants.userListOfGamesString, gameName: gameName)
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
