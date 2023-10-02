//
//  UnitConverter.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/23.
//

import Foundation

struct UnitConverter {
    
    static func milesToKilometers(miles: Double) -> Int {
        let conversionFactor = 1.60934
        let kilometers = miles * conversionFactor
        return Int(kilometers.rounded())
    }
    
}
