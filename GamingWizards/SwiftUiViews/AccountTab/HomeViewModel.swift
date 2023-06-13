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
//        @Published var isViewPersonalAccountViewPopUp: Bool = false
//        @Published var settingsIsActive: Bool = false
//        @Published var isUserManagingAccountShown: Bool = false
//        @Published var isShowingLogoutAlert: Bool = false
//        @Published var isFriendListShowing: Bool = false
        
        enum currentView {
            case settingsView
            case homeView
        }
        
        func changeViews() {
            
        }
        
    }
}
