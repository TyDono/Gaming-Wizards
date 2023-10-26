//
//  DataProcessor.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/24/23.
//

import Foundation


class DataProcessor {
    
    static func extractUserIDs(from friendEntity: [FriendEntity]) -> [String] {
        if !friendEntity.isEmpty {
            return friendEntity.map { $0.id ?? "" }
        } else {
            return [""]
        }
    }
    
    static func extractUserIDsFromBlockedUser(from blockedUserEntity: [BlockedUserEntity]) -> [String] {
        if !blockedUserEntity.isEmpty {
            return blockedUserEntity.map { $0.id ?? "" }
        } else {
            return [""]
        }
    }
    
}
