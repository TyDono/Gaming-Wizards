//
//  HomeViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/22.
//

import Foundation
import SwiftUI

extension HomeView {
    @MainActor class HomeViewModel: ObservableObject {
        
        enum currentView {
            case settingsView
            case homeView
        }
        
        func changeViews() {
            
        }
        
    }
}
