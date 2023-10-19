//
//  IsPayToPlaySearchSettingsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/9/23.
//

import Foundation
import SwiftUI


class IsPayToPlaySearchSettingsViewModel: ObservableObject {
    @ObservedObject var user: UserObservable
    @ObservedObject var coreDataController: CoreDataController
    @Published var isPayToPlay: Bool = false
    
    init(
        user: UserObservable = UserObservable.shared,
        coreDataController: CoreDataController = CoreDataController.shared
    ) {
        self.user = user
        self.coreDataController = coreDataController
    }
    
    func changeIsPayToPlay() {
        guard let isFreeToPlaySetting = coreDataController.savedSearchSettingsEntity?.isPayToPlay else { return }
        isPayToPlay = isFreeToPlaySetting
    }
    
    func saveIsPayToPlaySettings(isPayToPlay: Bool) {
        guard let newSearchSettings: SearchSettingsEntity = coreDataController.savedSearchSettingsEntity else { return }
        newSearchSettings.isPayToPlay = isPayToPlay
        do {
            try coreDataController.saveSearchSettings(searchSettings: newSearchSettings)
        } catch {
            print("ERROR SAVING SEARCH RADIUS TO SEARCH SETTINGS ENTITY: \(error)")
        }
    }
    
}
