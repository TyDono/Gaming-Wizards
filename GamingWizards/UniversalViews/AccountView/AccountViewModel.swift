//
//  AccountViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/26/23.
//

import Foundation
import SwiftUI

extension AccountView {
    @MainActor class AccountViewModel: ObservableObject {
        @ObservedObject var user = UserObservable.shared
        let fbFirestoreHelper = FirebaseFirestoreHelper()
        
        func callDeleteItemFromArray(tappedGame: String) {
            guard let userId = KeychainHelper.getUserID() else { return }
            fbFirestoreHelper.deleteItemFromArray(collectionName: Constants.usersString, documentField: userId, itemName: tappedGame, arrayField: Constants.userListOfGamesString) { [weak self] err, gameName  in
                if let error = err {
                    print("ERROR DELETING SPECIFIC GAME FROM USER'S LIST OF GAMES: \(error)")
                } else {
                    self?.user.listOfGames?.removeAll { $0 == gameName}
                }
            }
        }
        
        func callAddItemToArray(tappedGame: String) {
            guard let userId = KeychainHelper.getUserID() else { return }
            fbFirestoreHelper.addItemToArray(collectionName: Constants.usersString, documentField: userId, itemName: tappedGame, arrayField: Constants.userListOfGamesString) { [weak self] err, gameName  in
                if let error = err {
                    print("ERROR ADDING SPECIFIC GAME FROM USER'S LIST OF GAMES: \(error)")
                } else {
                    self?.user.listOfGames?.append(gameName)
                }
            }
        }
        
    }
}
