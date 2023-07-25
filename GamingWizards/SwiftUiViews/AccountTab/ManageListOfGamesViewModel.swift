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
        
        func updateColors(for selectedGameItem: FlowTag? = nil) {
            for index in gameItems.indices {
                if let selectedGameItem = selectedGameItem {
                    // Update colors only for the selected game item
                    if gameItems[index].id == selectedGameItem.id {
                        gameItems[index].textColor = Color.white
                        gameItems[index].backgroundColor = Color.blue
                    } else {
                        gameItems[index].textColor = Color.black
                        gameItems[index].backgroundColor = Color.lightGrey
                    }
                } else {
                    // Update colors for all game items based on the manageListOfGamesVM
                    let gameName = gameItems[index].textName
                    if user.listOfGames?.contains(gameName) ?? false {
                        gameItems[index].textColor = Color.white
                        gameItems[index].backgroundColor = Color.blue
                    } else {
                        gameItems[index].textColor = Color.black
                        gameItems[index].backgroundColor = Color.lightGrey
                    }
                }
            }
        }
        
    }
}
