//
//  Filterer.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/6/23.
//

import SwiftUI

class Filterer: ObservableObject {
    @Published var listOfGames: [FlowTag] = ListOfGames.name.map { FlowTag(gameName: $0) }
    @Published var emptyList: [FlowTag] = []
    @Published var searchText: String = ""
    let userListOfGames = UserObservable.shared.listOfGames

    init() {
        reorderSelectedGameItems()
        updateSelectedGames()
    }
    
    var gamesFilter: [FlowTag] {
        if searchText.isEmpty {
            return listOfGames.filter { $0.isSelected }
        } else {
            return listOfGames.filter { $0.textName.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func reorderSelectedGameItems() {
        withAnimation {
            listOfGames.sort { (item1, item2) in
                if item1.isSelected && !item2.isSelected {
                    return true
                } else if !item1.isSelected && item2.isSelected {
                    return false
                } else {
                    // If both are selected or both are not selected, sort alphabetically.
                    return item1.textName.localizedCaseInsensitiveCompare(item2.textName) == .orderedAscending
                }
            }
        }
    }
    
    func updateSelectedGames() {
        for game in listOfGames {
            game.isSelected = ((userListOfGames?.contains(game.textName)) == true)
        }
    }
    
}

