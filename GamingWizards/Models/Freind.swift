//
//  Freind.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/21/22.
//

import Foundation

struct Friend: Codable, Hashable, Identifiable {
    var id: String
    var friendCodeID: String
//    var friendUserID: String
    var displayName: String
    var isFriend: Bool
    var isFavorite: Bool
    var imageString: String
    
    var friendDictionary: [String: Any] {
        return [
            Constants.friendUserID: id,
            Constants.friendCodeID: friendCodeID,
//            "friendUserID": friendUserID,
            Constants.displayName: displayName,
            Constants.isFriend: isFriend,
            Constants.isFavorite: isFavorite,
            Constants.imageString: imageString
        ]
    }
}

extension User {
    enum FriendCodingKeys: String, CodingKey {
        case id = "id"
        case friendCodeID = "friend_code_id"
//        case friendUserID = "friend_user_id"
        case displayName = "display_name"
        case isFriend = "is_friend"
        case isFavorite = "is_favorite"
        case imageString = "image_string"

        init?(constantValue: String) {
            switch constantValue {
            case Constants.friendUserID:
                self = .id
            case Constants.friendCodeID:
                self = .friendCodeID
            case Constants.displayName:
                self = .displayName
            case Constants.isFriend:
                self = .isFriend
            case Constants.isFavorite:
                self = .isFavorite
            case Constants.imageString:
                self = .imageString
            default:
                return nil
            }
        }
        
    }
}
