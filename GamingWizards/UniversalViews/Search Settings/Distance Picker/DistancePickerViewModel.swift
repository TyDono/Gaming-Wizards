//
//  DistancePickerViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/23.
//

import Foundation
import SwiftUI
import Combine

//extension DistancePickerView {
class DistancePickerViewModel: ObservableObject {
    @ObservedObject var user: UserObservable
    @ObservedObject var coreDataController: CoreDataController
    @Published var miles: Double = 0.0
    @Published var kilometers: Int = 0
    @Published var savedSearchSettingsEntity: SearchSettingsEntity?
    @Published var savedSearchSettings: SearchSettings?
    @Published var isFailedToSavePayToPlayShowing: Bool = false
    private let firestoreService: FirebaseFirestoreService
    private var searchSettingsCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(
        user: UserObservable = UserObservable.shared,
        coreDataController: CoreDataController = CoreDataController.shared,
        miles: Double,
        kilometers: Int,
        firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper.shared
    ) {
        self.user = user
        self.miles = miles
        self.kilometers = kilometers
        self.coreDataController = coreDataController
        self.firestoreService = firestoreService
    }
    
    func callCoreDataEntities() async {
        self.searchSettingsCancellable = coreDataController.fetchSearchSettingsEntityPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { searchSettings in
                guard let searchSettings = searchSettings else { return }
                self.savedSearchSettings = SearchSettings(from: searchSettings)
                self.savedSearchSettingsEntity = searchSettings // remove later
                self.miles = searchSettings.searchRadius
            }
    }
    
    func searchSettingsIsBeingCanceled() {
        searchSettingsCancellable?.cancel()
    }
    
    func callSaveChangesToFirestore(oldSearchSettingsData: SearchSettings, newSearchSettingsData: SearchSettings) async {
            let saveChangesSuccess = await firestoreService.saveChangesToFirestore(from: oldSearchSettingsData, to: newSearchSettingsData, userId: user.id)
            switch saveChangesSuccess {
            case .success():
                saveDistanceSearchSettings(distance: newSearchSettingsData.searchRadius)
            case .failure(let error):
                print("ERROR UPDATING SEARCH SETTINGS RADIUS: \(error.localizedDescription)")
                miles = oldSearchSettingsData.searchRadius
                isFailedToSavePayToPlayShowing = true
            }
    }
    
    func convertMilesToKm(miles: Double) -> Int {
        return UnitConverter.milesToKilometers(miles: miles)
    }
    
    func saveDistanceSearchSettings(distance: Double) {
        guard let savedSearchSettings = savedSearchSettings else { return }
        var newSearchSettings = savedSearchSettings
        newSearchSettings.searchRadius = distance
        
        coreDataController.saveUserSearchSettingsToCoreData(newSearchSettings)
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
    }
    
    func mapExponential(value: Double) -> Double {
        let exponent = 1.5
        let maxValue: Double = 1000
        let midPoint: Double = 150
        
        if value <= midPoint {
            return pow(value / midPoint, exponent) * midPoint
        } else {
            return midPoint + pow((value - midPoint) / (maxValue - midPoint), exponent) * (maxValue - midPoint)
        }
    }
    
}
//}
