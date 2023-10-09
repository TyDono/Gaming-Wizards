//
//  ManageListOfGamesViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/18/23.
//

import Foundation
import SwiftUI

extension ManageListOfGamesView {
    @MainActor class ManageListOfGamesViewModel: ObservableObject {
        @ObservedObject var user = UserObservable.shared
        @Published var addGameButtonWasTapped: Bool = false
        @Published var isSearchButtonShowing: Bool = false
        @Published var isSearchError: Bool = false
        @Published var searchBarDropDownNotificationText: String = ""
        @Published var listOfGames: [String] = ListOfGames.name
        @Published var gameIsMatching: Bool = false
        @Published var gameItems: [FlowTag] = []
        let firebaseFirestoreHelper =  FirebaseFirestoreHelper.shared
        
        func gameTagWasTapped(tappedGameTag: FlowTag) {
            tappedGameTag.isSelected.toggle()
            if tappedGameTag.isSelected == true {
                saveGameToUserListOfGames(tappedGame: tappedGameTag.textName)
            } else {
                deleteGameFromUserListOfGames(tappedGame: tappedGameTag.textName)
            }
        }
        
        func saveGameToUserListOfGames(tappedGame: String) {
            guard let userId = KeychainHelper.getUserID() else { return }
            firebaseFirestoreHelper.addItemToArray(collectionName: Constants.usersString, documentField: userId, itemName: tappedGame, arrayField: Constants.userListOfGamesString) { [weak self] err, gameName  in
                if let error = err {
                    print("ERROR ADDING SPECIFIC GAME FROM USER'S LIST OF GAMES: \(error)")
                } else {
                    print("No error. Update successful.")
                    self?.user.listOfGames?.append(gameName)
                }
            }
        }

        
        func deleteGameFromUserListOfGames(tappedGame: String) {
            guard let userId = KeychainHelper.getUserID() else { return }
            firebaseFirestoreHelper.deleteItemFromArray(collectionName: Constants.usersString, documentField: userId, itemName: tappedGame, arrayField: Constants.userListOfGamesString) { [weak self] err, gameName  in
                if let error = err {
                    print("ERROR DELETING SPECIFIC GAME FROM USER'S LIST OF GAMES: \(error)")
                } else {
                    self?.user.listOfGames?.removeAll { $0 == gameName}
                }
            }
        }
        
        func updateGameTagsWithMatchingGames(filterer: [FlowTag]) {
            guard let listOfGames = user.listOfGames else { return }
            for gameItem in filterer {
                if listOfGames.contains(gameItem.textName) {
                    gameItem.isSelected = true
                }
            }
        }
        
    }
}
