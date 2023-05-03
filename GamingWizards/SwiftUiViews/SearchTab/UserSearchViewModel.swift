//
//  UserSearchViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/1/23.
//

import Combine
import SwiftUI
import Foundation

extension UserSearchView {
    @MainActor class UserSearchViewModel: ObservableObject {
//        @Published var listOfGames = [ListOfGames]()
        @Published var listOfGames = ListOfGames.name
        @Published var searchText: String = ""
        @Published var searchScope = SearchScope.inbox
        
        var filteredGames: [String] {
            if searchText.isEmpty {
                return [""]
            } else {
                return listOfGames.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }

        func runSearch() {
//            Task {
//                guard let url = URL(string: "https://hws.dev/\(searchScope.rawValue).json") else { return }
//
//                let (data, _) = try await URLSession.shared.data(from: url)
//                listOfGames = try JSONDecoder().decode([Message].self, from: data)
//            }
        }
        
    }
}
