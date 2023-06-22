//
//  AccountSettingsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/22/23.
//

import Foundation
import SwiftUI

extension AccountSettingsView {
    @MainActor class AccountSettingsViewModel: ObservableObject {
        @ObservedObject var user = UserObservable()
        
        
    }
}
