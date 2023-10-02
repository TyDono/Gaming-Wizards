//
//  SearchSettingsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/23.
//

import Foundation
import SwiftUI

//extension SearchSettingsView {
    class SearchSettingsViewModel: ObservableObject {
        @ObservedObject var distancePickerViewModel = DistancePickerViewModel(miles: 0.0, kilometers: 0)
    }
//}
