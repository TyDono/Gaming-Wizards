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
    
//    init(blockedUserId: String, data: [String: Any]) {
//        self.blockedUserId = blockedUserId
//        self.blockedUserId = data[Constants.blockedUsers] as? String ?? ""
//        self.displayName = data[Constants.displayName] as? String ?? ""
//        self.dateRemoved = data[Constants.dateRemoved] as? Date ?? Date()   
//    } 
    
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
