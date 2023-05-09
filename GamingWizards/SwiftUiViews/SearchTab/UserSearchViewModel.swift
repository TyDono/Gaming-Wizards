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

extension UserSearchView {
    @MainActor class UserSearchViewModel: ObservableObject {
//        @Published var listOfGames = [ListOfGames]()
        @Published var listOfGames = ListOfGames.name
        @Published var searchText: String = ""
        @Published var searchScope = SearchScope.inbox
        let firesStoreDatabase = Firestore.firestore()
//        @ObservedObject var searchResultsViewModel = SearchResultsViewModel()
        
        func sendDataToSearchResultsViewModel() {
            
        }
        
        func performSearchForMatchingGames(game: String, completion: @escaping ([String]?, Error?) -> Void) {
            let gameQuery = firesStoreDatabase.collection("users").whereField("game", isEqualTo: game)

            gameQuery.getDocuments { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let snapshot = snapshot else {
                    completion(nil, nil)
                    return
                }
                let names = snapshot.documents.compactMap { $0.get("name") as? String }
                completion(names, nil)
            }
        }
        
        var filteredGames: [String] {
            if searchText.isEmpty {
                return [""]
            } else {
                return listOfGames.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
    }
}
