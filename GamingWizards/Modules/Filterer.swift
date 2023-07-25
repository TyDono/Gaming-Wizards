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

    var gamesFilter: [FlowTag] {
        if searchText.isEmpty {
            return listOfGames
        } else {
            return listOfGames.filter { $0.textName.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

