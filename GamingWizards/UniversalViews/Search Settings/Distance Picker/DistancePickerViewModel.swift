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
        private var searchSettingsCancellable: AnyCancellable?
        
        init(
            coreDataController: CoreDataController = CoreDataController.shared,
            miles: Double, //= CoreDataController.shared.savedSearchSettingsEntity?.searchRadius ?? 0,
            kilometers: Int
        ) {
            self.miles = miles
            self.kilometers = kilometers
            self.coreDataController = coreDataController
        }
        
        func callCoreDataEntities() async {
            self.searchSettingsCancellable = coreDataController.fetchSearchSettingsEntityPublisher()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }) { searchSettings in
                    self.savedSearchSettingsEntity = searchSettings
                }
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
            let exponent = 1.5 // You can adjust the exponent based on your preference
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
