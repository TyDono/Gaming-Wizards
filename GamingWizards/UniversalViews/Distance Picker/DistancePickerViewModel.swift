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
        
    }
//}
