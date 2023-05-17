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
        
        func sendDataToSearchResultsViewModel() {
            
        }
        
        func callPerformSearchForMatchingGames(gameName: String) { //not used
            performSearchForMatchingGames(gameName: gameName) { users, err in
                guard let usersUnwrapped = users else { return }
                self.users = usersUnwrapped
                //change both user values here
            }
        }
        
        func performSearchForMatchingGames(gameName: String, completion: @escaping ([User]?, Error?) -> Void) {
            let gameQuery = firesStoreDatabase.collection(Constants.users).whereField(Constants.userGames, arrayContains: gameName)

            gameQuery.getDocuments { (snapshot, err) in
                if let error = err {
                    print("ERROR FETCHING SEARCHED FOR USERS\(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                guard let snapshot = snapshot else {
                    completion(nil, nil)
                    return
                }
                let users = snapshot.documents.map { (document) -> User in
                    let data = document.data()
                    let id = data["is"] as? String ?? ""
                    let displayName = data["displayName"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let location = data[""] as? String ?? ""
                    let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                    let friendID = data["friendId"] as? String ?? ""
                    let games = data["games"] as? [String] ?? [""]
                    let groupSize = data["groupSize"] as? String ?? ""
                    let age = data["age"] as? String ?? ""
                    let about = data["bout"] as? String ?? ""
                    
                    return User(id: id, displayName: displayName, email: email, location: location, profileImageUrl: profileImageUrl, friendID: friendID, games: games, groupSize: groupSize, age: age, about: about)
                }
                
                completion(users, err)
                
                /*
                    i need id for sending a friend request,
                     name
                     title
                     game
                     age
                     group size
                     about
                     location. for now location will just be text based a state, city. and or remote as an option.
                     availability add this to users later
                     */
//                let names = snapshot.documents.compactMap { $0.get("name") as? String }
//                completion(names, nil)
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
//}
