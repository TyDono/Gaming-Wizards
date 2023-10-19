//
//  DistancePickerViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/23.
//

import Foundation
import SwiftUI

//extension DistancePickerView {
    class DistancePickerViewModel: ObservableObject {
        @ObservedObject var coreDataController: CoreDataController
        @Published var miles: Double = 0.0
        @Published var kilometers: Int = 0
        
        init(
            coreDataController: CoreDataController = CoreDataController.shared,
            miles: Double, //= CoreDataController.shared.savedSearchSettingsEntity?.searchRadius ?? 0,
            kilometers: Int
        ) {
            self.miles = miles
            self.kilometers = kilometers
            self.coreDataController = coreDataController
        }
        
        func convertMilesToKm(miles: Double) -> Int {
            return UnitConverter.milesToKilometers(miles: miles)
        }
        
        func saveDistanceSearchSettings(distance: Double) {
            guard let newSearchSettings = coreDataController.savedSearchSettingsEntity else { return }
            newSearchSettings.searchRadius = distance
            do {
                print(newSearchSettings.searchRadius)
                try coreDataController.saveSearchSettings(searchSettings: newSearchSettings)
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
