//
//  IsPayToPlaySearchSettingsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/9/23.
//

import Foundation
import SwiftUI
import Combine


class IsPayToPlaySearchSettingsViewModel: ObservableObject {
    @ObservedObject var user: UserObservable
    @ObservedObject var coreDataController: CoreDataController
    @Published var isPayToPlay: Bool = false
    @Published var savedSearchSettingsEntity: SearchSettingsEntity?
    private var searchSettingsCancellable: AnyCancellable?
    
    init(
        user: UserObservable = UserObservable.shared,
        coreDataController: CoreDataController = CoreDataController.shared
    ) {
        self.user = user
        self.coreDataController = coreDataController
        self.searchSettingsCancellable = coreDataController.fetchSearchSettingsEntityPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { searchSettings in
                self.savedSearchSettingsEntity = searchSettings
            }
    }
    
    func changeIsPayToPlay() {
        guard let isFreeToPlaySetting = savedSearchSettingsEntity?.isPayToPlay else { return }
        isPayToPlay = isFreeToPlaySetting
    }
    
    func saveIsPayToPlaySettings(isPayToPlay: Bool) {
        guard let newSearchSettings: SearchSettingsEntity = savedSearchSettingsEntity else { return }
        newSearchSettings.isPayToPlay = isPayToPlay
        do {
            try coreDataController.saveSearchSettingsToCoreData(searchSettings: newSearchSettings)
        } catch {
            print("ERROR SAVING SEARCH RADIUS TO SEARCH SETTINGS ENTITY: \(error)")
        }
    }
    
}
