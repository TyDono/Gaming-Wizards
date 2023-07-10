//
//  UserSearchViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/1/23.
//

import SwiftUI

//extension UserSearchView {
    @MainActor class UserSearchViewModel: ObservableObject {
//        @Published var listOfGames = [ListOfGames]()
        @Published var listOfGames = ListOfGames.name
//        @Published var searchText: String = ""
        @Published var searchScope = SearchScope.inbox
        @Published var users: [User] = []
        @Published var searchBarDropDownNotificationText: String = "You must select a viable option from the list"
//        @ObservedObject var filterer = Filterer()
        
//        var filteredGames: [String] {
//            if searchText.isEmpty {
//                return [""]
//            } else {
//                return listOfGames.filter { $0.localizedCaseInsensitiveContains(searchText) }
//            }
//        }
        
    }
//}
