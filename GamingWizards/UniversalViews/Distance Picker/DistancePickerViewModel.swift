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
        @Published var miles: Double = 0.0
        @Published var kilometers: Int = 0
        
        init(miles: Double, kilometers: Int) {
            self.miles = miles
            self.kilometers = kilometers
        }
        
        func convertMilesToKm(miles: Double) -> Int {
            return UnitConverter.milesToKilometers(miles: miles)
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