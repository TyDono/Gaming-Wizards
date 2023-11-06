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
    @Published var userSearchSettings: SearchSettings?
    @Published var isFailedToSavePayToPlayShowing: Bool = false
    private let firestoreService: FirebaseFirestoreService
    private var searchSettingsCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    let convertToFriend = ConvertToFriend()
    
    init(
        user: UserObservable = UserObservable.shared,
        coreDataController: CoreDataController = CoreDataController.shared,
        firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper.shared
    ) {
        self.user = user
        self.coreDataController = coreDataController
        self.firestoreService = firestoreService
    }
    
    func callCoreDataEntities() async {
        self.searchSettingsCancellable = coreDataController.fetchSearchSettingsEntityPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { searchSettings in
                guard let searchSettingsEntity = searchSettings else { return }
                self.userSearchSettings = SearchSettings(from: searchSettingsEntity)
                self.changeIsPayToPlay()
            }
    }
    
    func searchSettingsIsBeingCanceled() {
        searchSettingsCancellable?.cancel()
    }
    
    func changeIsPayToPlay() {
        guard let userSearchSettings = userSearchSettings else { return  }
        isPayToPlay = userSearchSettings.isPayToPlay
    }
    
    func callSaveChangesToFirestore(oldSearchSettingsData: SearchSettings, newSearchSettingsData: SearchSettings) async {
            let saveChangesSuccess = await firestoreService.saveChangesToFirestore(from: oldSearchSettingsData, to: newSearchSettingsData, userId: user.id)
            switch saveChangesSuccess {
            case .success():
                saveIsPayToPlaySettings(isPayToPlay: newSearchSettingsData.isPayToPlay)
            case .failure(let error):
                print("ERROR CREATING DUAL RECENT MESSAGE: \(error.localizedDescription)")
                userSearchSettings?.isPayToPlay.toggle()
                isFailedToSavePayToPlayShowing = true
            }
    }
    
    func saveIsPayToPlaySettings(isPayToPlay: Bool) {
        guard userSearchSettings != nil else { return }
        userSearchSettings?.isPayToPlay = isPayToPlay
        do {
            coreDataController.saveUserSearchSettingsToCoreData(userSearchSettings!)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Failed to save search settings: \(error)")
                    }
                }, receiveValue: { savedEntity in
                    print("Search settings saved: \(savedEntity)")
                })
                .store(in: &cancellables)
        } catch {
            print("ERROR SAVING SEARCH RADIUS TO SEARCH SETTINGS ENTITY: \(error)")
        }
    }
    
}
