//
//  SearchResultsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore

//extension SearchResultsView {
    @MainActor class SearchResultsViewModel: ObservableObject {
        @Published var searchText: String = ""
        @Published var users: [User]? = []
        let firesStoreDatabase = Firestore.firestore()
        
        func lfgResultWasTapped() {
            //perform segue/navigation here and jazz
        }
        
        func callPerformSearchForMatchingGames(gameName: String) {
            performSearchForMatchingGames(gameName: gameName) { user, err in
                if let error = err {
                    print("callPerformSearchForMatchingGames ERROR: \(error.localizedDescription)")
                    return
                }
                guard let usersUnwrapped = user else { return }
                self.users = usersUnwrapped
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
                    let availability = data["availability"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    
                    return User(id: id, displayName: displayName, email: email, location: location, profileImageUrl: profileImageUrl, friendID: friendID, games: games, groupSize: groupSize, age: age, about: about, availability: availability,  title: title)
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
        
    }
//}
