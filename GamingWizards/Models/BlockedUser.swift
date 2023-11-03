//
//  BlockedUser.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/25/23.
//

import Foundation

struct BlockedUser:Identifiable, Codable {
    var id: String 
    var displayName: String
    var dateRemoved: Date
    
    init(data: [String: Any]) {
        self.id = data[Constants.idStringValue] as? String ?? ""
        self.displayName = data[Constants.displayName] as? String ?? ""
        self.dateRemoved = data[Constants.dateRemoved] as? Date ?? Date()   
    } 
    
    init(from entity: BlockedUserEntity) {
        self.id = entity.id ?? ""
        self.displayName = entity.displayName ?? ""
        self.dateRemoved = entity.dateRemoved ?? Date()
    }
    
    enum BlockedUserCodingKeys: String, CodingKey {
        case id = "id"
        case displayName = "displayName"
        case dateRemoved = "dateRemoved"
    }
    
    var blockedUserDictionary: [String: Any] {
        return [
            Constants.idStringValue: id,
            Constants.displayName: displayName,
            Constants.dateRemoved: dateRemoved
        ]
    }
    
}
