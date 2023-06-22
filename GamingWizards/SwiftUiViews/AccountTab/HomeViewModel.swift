//
//  HomeViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/22.
//

import SwiftUI

extension HomeView {
    @MainActor class HomeViewModel: ObservableObject {
//        @Published var isShowingEditAccountView: Bool = false
//        @Published var isViewPersonalAccountViewPopUp: Bool = false
//        @Published var settingsIsActive: Bool = false
//        @Published var isUserManagingAccountShown: Bool = false
//        @Published var isShowingLogoutAlert: Bool = false
//        @Published var isFriendListShowing: Bool = false
//        @Published var isAccountSettingsShowing: Bool = false
        
        enum currentView {
            case settingsView
            case homeView
        }
        
        func changeViews() {
            
        }
        
    }
}
