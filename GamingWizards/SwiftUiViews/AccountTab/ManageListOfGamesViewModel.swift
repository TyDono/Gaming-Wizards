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
        
    }
}
