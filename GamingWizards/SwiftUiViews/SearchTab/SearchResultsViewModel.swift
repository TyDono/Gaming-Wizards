//
//  SearchResultsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI
import FirebaseFirestore

//extension SearchResultsView {
    @MainActor class SearchResultsViewModel: ObservableObject {
        @Published var searchText: String = ""
        @Published var users: [User]? = []
        let firesStoreDatabase = Firestore.firestore()
        
//        func callPerformSearchForMatchingGames(gameName: String) {
//            perform
//            performSearchForMatchingGames(gameName: gameName) { user, err in
//                if let error = err {
//                    print("callPerformSearchForMatchingGames ERROR: \(error.localizedDescription)")
//                    return
//                }
//                guard let usersUnwrapped = user else { return }
//                self.users = usersUnwrapped
//            }
//        }
        
        func performSearchForMatchingGames(gameName: String) {
            Task {
                do {
                    self.users = try await searchForMatchingGames(gameName: gameName)
                } catch {
                    // Handle the error here
                    print("Error: \(error)")
                }
            }
        }
        
        func searchForMatchingGames(gameName: String) async throws -> [User] {
            let gameQuery = firesStoreDatabase.collection(Constants.users).whereField(Constants.userListOfGamesString, arrayContains: gameName)
            
            do {
                let snapshot = try await gameQuery.getDocuments()
                let users = snapshot.documents.map { document -> User in
                    let data = document.data()
                    let id = data[Constants.userID] as? String ?? ""
                    let displayName = data[Constants.userDisplayName] as? String ?? ""
                    let email = data[Constants.userEmail] as? String ?? ""
                    let location = data[""] as? String ?? ""
                    let profileImageString = data[Constants.userProfileImageString] as? String ?? ""
                    let friendCodeID = data[Constants.userFriendID] as? String ?? ""
                    let listOfGames = data[Constants.userListOfGamesString] as? [String] ?? [""]
                    let groupSize = data[Constants.userGroupSize] as? String ?? ""
                    let age = data[Constants.userAge] as? String ?? ""
                    let about = data[Constants.userAbout] as? String ?? ""
                    let availability = data[Constants.userAvailability] as? String ?? ""
                    let title = data[Constants.userTitle] as? String ?? ""
                    let payToPlay = data[Constants.userPayToPlay] as? Bool ?? false
                    let isSolo = data[Constants.userIsSolo] as? Bool ?? true
                    
                    return User(id: id, displayName: displayName, email: email, location: location, profileImageString: profileImageString, friendCodeID: friendCodeID, listOfGames: listOfGames, groupSize: groupSize, age: age, about: about, availability: availability, title: title, isPayToPlay: payToPlay, isSolo: isSolo)
                }
                
                return users
            } catch {
                print("ERROR FETCHING SEARCHED FOR USERS: \(error.localizedDescription)")
                throw error
            }
        }


        
//        func performSearchForMatchingGamesAwait(gameName: String, completion: @escaping ([User]?, Error?) -> Void) { // NOT USED
//            let gameQuery = firesStoreDatabase.collection(Constants.users).whereField(Constants.userListOfGamesString, arrayContains: gameName)
//
//            gameQuery.getDocuments { (snapshot, err) in
//                if let error = err {
//                    print("ERROR FETCHING SEARCHED FOR USERS\(error.localizedDescription)")
//                    completion(nil, error)
//                    return
//                }
//                guard let snapshot = snapshot else {
//                    completion(nil, nil)
//                    return
//                }
//                let users = snapshot.documents.map { (document) -> User in
//                    let data = document.data()
//                    let id = data[Constants.userID] as? String ?? ""
//                    let displayName = data[Constants.userDisplayName] as? String ?? ""
//                    let email = data[Constants.userEmail] as? String ?? ""
//                    let location = data[""] as? String ?? ""
//                    let profileImageString = data[Constants.userProfileImageString] as? String ?? ""
//                    let friendCodeID = data[Constants.userFriendID] as? String ?? ""
//                    let listOfGames = data[Constants.userListOfGamesString] as? [String] ?? [""]
//                    let groupSize = data[Constants.userGroupSize] as? String ?? ""
//                    let age = data[Constants.userAge] as? String ?? ""
//                    let about = data[Constants.userAbout] as? String ?? ""
//                    let availability = data[Constants.userAvailability] as? String ?? ""
//                    let title = data[Constants.userTitle] as? String ?? ""
//                    let payToPlay = data[Constants.userPayToPlay] as? Bool ?? false
//                    let isSolo = data[Constants.userIsSolo] as? Bool ?? true
//
//                    return User(id: id, displayName: displayName, email: email, location: location, profileImageString: profileImageString, friendCodeID: friendCodeID, listOfGames: listOfGames, groupSize: groupSize, age: age, about: about, availability: availability, title: title, isPayToPlay: payToPlay, isSolo: isSolo)
//                }
//                completion(users, err)
////                let names = snapshot.documents.compactMap { $0.get("name") as? String }
////                completion(names, nil)
//            }
//        }
        
    }
//}
