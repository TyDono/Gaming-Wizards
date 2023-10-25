//
//  DataProcessor.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/24/23.
//

import Foundation


class DataProcessor {
    
    static func extractUserIDs(from friendEntity: [FriendEntity]) -> [String] {
        return friendEntity.map { $0.id ?? "" }
    }
    
    static func extractUserIDsFromBlockedUser(from blockedUserEntity: [BlockedUserEntity]) -> [String] {
        return blockedUserEntity.map { $0.id ?? "" }
    }
    
}
