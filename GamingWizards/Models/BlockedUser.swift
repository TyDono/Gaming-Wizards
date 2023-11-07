//
//  BlockedUser.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/25/23.
//

import Foundation

struct BlockedUser: Identifiable, Codable {
    
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

extension BlockedUser: Updatable {
    
    func updatedFields<U: Updatable>(from other: U) -> [String: Any] {
        guard let otherUser = other as? BlockedUser else {
            return [:]
        }
        var updatedFields: [String: Any] = [:]
        
        if self.id != otherUser.id {
            updatedFields[BlockedUserCodingKeys.id.rawValue] = self.id
        }
        
        if self.displayName != otherUser.displayName {
            updatedFields[BlockedUserCodingKeys.displayName.rawValue] = self.displayName
        }
        
        if self.dateRemoved != otherUser.dateRemoved {
            updatedFields[BlockedUserCodingKeys.dateRemoved.rawValue] = self.dateRemoved
        }
        
        return updatedFields
    }
    
}
