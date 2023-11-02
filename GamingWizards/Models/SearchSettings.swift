//
//  SearchSettings.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/2/23.
//

import Foundation


struct SearchSettings: Hashable, Codable {
    var ageRangeMax: Int
    var ageRangeMin: Int
    var groupSizeRangeMax: Int
    var groupSizeRangeMin: Int
    var isPayToPlay: Bool
    var searchRadius: Double
    
    var searchSettingDictionary: [String: Any] {
        return [
            Constants.ageRangeMax: ageRangeMax,
            Constants.ageRangeMin: ageRangeMin,
            Constants.groupSizeRangeMax: groupSizeRangeMax,
            Constants.groupSizeRangeMin: groupSizeRangeMin,
            Constants.isPayToPlay: isPayToPlay,
            Constants.searchRadius: searchRadius
        ]
    }
    
    
    init(data: [String: Any]) {
        self.ageRangeMax = data[Constants.ageRangeMax] as? Int ?? 0
        self.ageRangeMin = data[Constants.ageRangeMin] as? Int ?? 0
        self.groupSizeRangeMax = data[Constants.groupSizeRangeMax] as? Int ?? 0
        self.groupSizeRangeMin = data[Constants.groupSizeRangeMin] as? Int ?? 0
        self.isPayToPlay = data[Constants.isPayToPlay] as? Bool ?? false
        self.searchRadius = data[Constants.searchRadius] as? Double ?? 0.0
    }
    
}

extension Friend {
    enum SearchSettingDictionaryCodingKeys: String, CodingKey {
        case ageRangeMax = "ageRangeMax"
        case ageRangeMin = "ageRangeMin"
        case groupSizeRangeMax = "groupSizeRangeMax"
        case groupSizeRangeMin = "groupSizeRangeMin"
        case isPayToPlay = "isPayToPlay"
        case searchRadius = "searchRadius"

        init?(constantValue: String) {
            switch constantValue {
            case Constants.ageRangeMax:
                self = .ageRangeMax
            case Constants.ageRangeMin:
                self = .ageRangeMin
            case Constants.groupSizeRangeMax:
                self = .groupSizeRangeMax
            case Constants.groupSizeRangeMin:
                self = .groupSizeRangeMin
            case Constants.isPayToPlay:
                self = .isPayToPlay
            case Constants.searchRadius:
                self = .searchRadius
                
            default:
                return nil
            }
        }
        
    }
}
