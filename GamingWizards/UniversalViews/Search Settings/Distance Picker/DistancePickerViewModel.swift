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
        @ObservedObject var coreDataController: CoreDataController
        @Published var miles: Double = 0.0
        @Published var kilometers: Int = 0
        @Published var savedSearchSettingsEntity: SearchSettingsEntity?
        private let firestoreService: FirebaseFirestoreService
        private var searchSettingsCancellable: AnyCancellable?
        
        init(
            coreDataController: CoreDataController = CoreDataController.shared,
            miles: Double, //= CoreDataController.shared.savedSearchSettingsEntity?.searchRadius ?? 0,
            kilometers: Int,
            firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper.shared
        ) {
            self.miles = miles
            self.kilometers = kilometers
            self.coreDataController = coreDataController
            self.firestoreService = firestoreService
        }
        
        func callCoreDataEntities() async {
            self.searchSettingsCancellable = coreDataController.fetchSearchSettingsEntityPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }) { searchSettings in
                    self.savedSearchSettingsEntity = searchSettings
                    self.miles = searchSettings?.searchRadius ?? 10.0
                }
        }
        
        func searchSettingsIsBeingCanceled() {
            searchSettingsCancellable?.cancel()
        }
        
        func callSaveUserSearchSettings() {
            //have a debouncer
        }
        
        func convertMilesToKm(miles: Double) -> Int {
            return UnitConverter.milesToKilometers(miles: miles)
        }
        
        func saveDistanceSearchSettings(distance: Double) {
            guard let newSearchSettings = savedSearchSettingsEntity else { return }
            newSearchSettings.searchRadius = distance
            do {
                try coreDataController.saveSearchSettingsToCoreData(searchSettings: newSearchSettings)
            } catch {
                print("ERROR SAVING SEARCH RADIUS TO SEARCH SETTINGS ENTITY: \(error)")
            }
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
