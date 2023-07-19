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
        
    }
}
