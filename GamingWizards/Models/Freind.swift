//
//  Freind.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/21/22.
//

import Foundation

struct Friend: Codable, Hashable, Identifiable {
    var friendCodeID: String
    var friendUserID: String
    var friendDisplayName: String
    var isFriend: Bool
    var isFavorite: Bool
    
    var id: String { friendUserID }
    
    var friendDictionary: [String: Any] {
        return [
            "id": id,
            "friendCodeID": friendCodeID,
            "friendUserID": friendUserID,
            "friendDisplayName": friendDisplayName,
            "isFriend": isFriend,
            "isFavorite": isFavorite
        ]
    }
}

extension User {
    enum FriendCodingKeys: String, CodingKey {
        case id = "id"
        case friendCodeID = "friend_code_id"
        case friendUserID = "friend_user_id"
        case friendDisplayName = "friend_display_name"
        case isFriend = "is_friend"
        case isFavorite = "isFavorite"

    }
}
