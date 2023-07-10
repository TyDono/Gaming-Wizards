//
//  Filterer.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/6/23.
//

import SwiftUI

class Filterer: ObservableObject {
    
    @Published var listOfGames: [String] = ListOfGames.name
    @Published var searchText: String = ""
    
    var gamesFilter: [String] {
        if searchText.isEmpty {
            return [""]
        } else {
            return listOfGames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
}
