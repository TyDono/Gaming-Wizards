//
//  SearchSettings.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/2/23.
//

import Foundation


struct SearchSettings: Hashable, Codable, Updatable {
    
    var ageRangeMax: Int
    var ageRangeMin: Int
    var groupSizeRangeMax: Int
    var groupSizeRangeMin: Int
    var isPayToPlay: Bool
    var searchRadius: Double
    
    init(
        ageRangeMax: Int = 0,
        ageRangeMin: Int = 0,
        groupSizeRangeMax: Int = 0,
        groupSizeRangeMin: Int = 0,
        isPayToPlay: Bool = false,
        searchRadius: Double = 0.0
    ) {
        self.ageRangeMax = ageRangeMax
        self.ageRangeMin = ageRangeMin
        self.groupSizeRangeMax = groupSizeRangeMax
        self.groupSizeRangeMin = groupSizeRangeMin
        self.isPayToPlay = isPayToPlay
        self.searchRadius = searchRadius
    }
    
    init(data: [String: Any]) {
        self.ageRangeMax = data[Constants.ageRangeMax] as? Int ?? 0
        self.ageRangeMin = data[Constants.ageRangeMin] as? Int ?? 0
        self.groupSizeRangeMax = data[Constants.groupSizeRangeMax] as? Int ?? 0
        self.groupSizeRangeMin = data[Constants.groupSizeRangeMin] as? Int ?? 0
        self.isPayToPlay = data[Constants.isPayToPlay] as? Bool ?? false
        self.searchRadius = data[Constants.searchRadius] as? Double ?? 0.0
    }
    
    init(from entity: SearchSettingsEntity) {
        self.ageRangeMax = Int(entity.ageRangeMax)
        self.ageRangeMin = Int(entity.ageRangeMin)
        self.groupSizeRangeMax = Int(entity.groupSizeRangeMax)
        self.groupSizeRangeMin = Int(entity.groupSizeRangeMin)
        self.isPayToPlay = entity.isPayToPlay
        self.searchRadius = entity.searchRadius
    }
    
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
    
    func updatedFields<T>(from other: T) -> [String: Any] where T: Updatable {
        var changes: [String: Any] = [:]

        if let otherSettings = other as? SearchSettings {
            if self.ageRangeMax != otherSettings.ageRangeMax {
                changes["ageRangeMax"] = self.ageRangeMax
            }

            if self.ageRangeMin != otherSettings.ageRangeMin {
                changes["ageRangeMin"] = self.ageRangeMin
            }

            if self.groupSizeRangeMax != otherSettings.groupSizeRangeMax {
                changes["groupSizeRangeMax"] = self.groupSizeRangeMax
            }

            if self.groupSizeRangeMin != otherSettings.groupSizeRangeMin {
                changes["groupSizeRangeMin"] = self.groupSizeRangeMin
            }

            if self.isPayToPlay != otherSettings.isPayToPlay {
                changes["isPayToPlay"] = self.isPayToPlay
            }

            if self.searchRadius != otherSettings.searchRadius {
                changes["searchRadius"] = self.searchRadius
            }
        }

        return changes
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
