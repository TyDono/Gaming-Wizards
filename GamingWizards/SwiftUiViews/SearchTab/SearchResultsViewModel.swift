//
//  SearchResultsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import Foundation
import SwiftUI

extension SearchResultsView {
    @MainActor class SearchResultsViewModel: ObservableObject {
        @Published var searchText: String = ""
        
        func lfgResultWasTapped() {
            //perform segue/navigation here and jazz
        }
        
    }
}
