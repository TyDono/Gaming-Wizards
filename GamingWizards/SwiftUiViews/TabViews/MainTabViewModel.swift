//
//  MainTabViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 1/9/23.
//

import SwiftUI

extension MainTabView {
    @MainActor class MainTabViewModel: ObservableObject {
        @EnvironmentObject var mainTabViewModel: MainTabViewModel
        
    }
}
