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
        let firebaseHelper = FirebaseFirestoreHelper()
        
        func performSearchForMatchingGames(gameName: String) async {
            Task {
                do {
                    self.users = try await firebaseHelper.searchForMatchingGames(collectionName: Constants.users, whereField: Constants.userListOfGamesString, gameName: gameName)
                } catch {
                    print("ERROR RETRIEVING MATCHING GAMES FROM SEARCH: \(error)")
                }
            }
        }
        
    }
}
