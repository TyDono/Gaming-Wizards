//
//  UserSearchViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/1/23.
//

import Combine
import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore

//extension UserSearchView {
    @MainActor class UserSearchViewModel: ObservableObject {
//        @Published var listOfGames = [ListOfGames]()
        @Published var listOfGames = ListOfGames.name
        @Published var searchText: String = ""
        @Published var searchScope = SearchScope.inbox
        @Published var users: [User] = []
        let firesStoreDatabase = Firestore.firestore()
//        @ObservedObject var searchResultsViewModel = SearchResultsViewModel()
        
        var filteredGames: [String] {
            if searchText.isEmpty {
                return [""]
            } else {
                return listOfGames.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
    }
//}
