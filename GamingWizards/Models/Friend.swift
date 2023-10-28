//
//  Friend.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/21/22.
//

import Foundation
import Firebase

struct Friend: Codable, Hashable, Identifiable {
    var id: String
    var displayName: String
    var isFriend: Bool
    var isFavorite: Bool
    var imageString: String
    var recentMessageText: String
    var recentMessageTimeStamp: Timestamp
    var onlineStatus: Bool
    var messageToId: String
    
    var friendDictionary: [String: Any] {
        return [
            Constants.friendUserID: id,
            Constants.displayName: displayName,
            Constants.isFriend: isFriend,
            Constants.isFavorite: isFavorite,
            Constants.imageString: imageString,
            Constants.recentMessageText: recentMessageText,
            Constants.recentMessageTimeStamp: recentMessageTimeStamp,
            Constants.onlineStatus: onlineStatus,
            Constants.messageToId: messageToId
        ]
    }
    
    /*
    init(data: [String: Any]) {
        self.id = data[Constants.idStringValue] as? String ?? ""
        self.displayName = data[Constants.displayName] as? String ?? ""
        self.isFriend = data[Constants.isFriend] as? Bool ?? false
        self.isFavorite = data[Constants.isFriend] as? Bool ?? false
        self.imageString = data[Constants.imageString] as? String ?? ""
        
        self.recentMessageText = data[Constants.recentMessageText] as? String ?? ""
        self.recentMessageTimeStamp = data[Constants.recentMessageTimeStamp] as? Timestamp ?? Timestamp(date: Date())
        self.onlineStatus = data[Constants.onlineStatus] as? Bool ?? false
        self.messageToId = data[Constants.messageToId] as? String ?? ""
    }
    
     */
}

extension Friend {
    enum FriendCodingKeys: String, CodingKey {
        case id = "id"
        case displayName = "display_name"
        case isFriend = "is_friend"
        case isFavorite = "is_favorite"
        case imageString = "image_string"
        case recentMessageText = "recent_message_text"
        case recentMessageTimeStamp = "recent_message_timeStamp"
        case onlineStatus = "online_status"
        case messageToId = "message_to_id"

        init?(constantValue: String) {
            switch constantValue {
            case Constants.friendUserID:
                self = .id
            case Constants.displayName:
                self = .displayName
            case Constants.isFriend:
                self = .isFriend
            case Constants.isFavorite:
                self = .isFavorite
            case Constants.imageString:
                self = .imageString
            case Constants.recentMessageText:
                self = .recentMessageText
            case Constants.recentMessageTimeStamp:
                self = .recentMessageTimeStamp
            case Constants.onlineStatus:
                self = .onlineStatus
            case Constants.messageToId:
                self = .messageToId
                
            default:
                return nil
            }
        }
        
    }
}
