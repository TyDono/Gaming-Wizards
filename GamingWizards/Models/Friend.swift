//
//  Friend.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/21/22.
//

import Foundation
import Firebase
import CoreData

struct Friend: Codable, Hashable, Identifiable {
    var id: String
    var displayName: String
    var isFriend: Bool
    var isFavorite: Bool
    var imageString: String
    var recentMessageText: String
    var recentMessageTimeStamp: Date
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
    
    init(data: [String: Any]) {
        self.id = data[Constants.idStringValue] as? String ?? ""
        self.displayName = data[Constants.displayName] as? String ?? ""
        self.isFriend = data[Constants.isFriend] as? Bool ?? false
        self.isFavorite = data[Constants.isFriend] as? Bool ?? false
        self.imageString = data[Constants.imageString] as? String ?? ""
        
        self.recentMessageText = data[Constants.recentMessageText] as? String ?? ""
        self.recentMessageTimeStamp = data[Constants.recentMessageTimeStamp] as? Date ?? Date()
        self.onlineStatus = data[Constants.onlineStatus] as? Bool ?? false
        self.messageToId = data[Constants.messageToId] as? String ?? ""
    }
    
     
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

extension Friend: Updatable {
    
    func updatedFields<T>(from other: T) -> [String: Any] where T: Updatable {
        var changes: [String: Any] = [:]

        if let otherFriend = other as? Friend {
            if self.displayName != otherFriend.displayName {
                changes[Constants.displayName] = self.displayName
            }

            if self.isFriend != otherFriend.isFriend {
                changes[Constants.isFriend] = self.isFriend
            }

            if self.isFavorite != otherFriend.isFavorite {
                changes[Constants.isFavorite] = self.isFavorite
            }

            if self.imageString != otherFriend.imageString {
                changes[Constants.imageString] = self.imageString
            }

            if self.recentMessageText != otherFriend.recentMessageText {
                changes[Constants.recentMessageText] = self.recentMessageText
            }

            if self.recentMessageTimeStamp != otherFriend.recentMessageTimeStamp {
                changes[Constants.chatMessageTimeStamp] = self.recentMessageTimeStamp
            }

            if self.onlineStatus != otherFriend.onlineStatus {
                changes[Constants.onlineStatus] = self.onlineStatus
            }

            if self.messageToId != otherFriend.messageToId {
                changes[Constants.messageToId] = self.messageToId
            }
        }

        return changes
    }
    
}

//extension Friend {
//    init(coreDataEntity: FriendEntity) {
//        self.name = coreDataEntity.name ?? ""
//        self.age = Int(coreDataEntity.age)
//    }
//
//    func toCoreDataEntity(in context: NSManagedObjectContext) -> FriendEntity {
//        let friendEntity = FriendEntity(context: context)
//        friendEntity.name = self.name
//        friendEntity.age = Int16(self.age)
//        return friendEntity
//    }
//}
