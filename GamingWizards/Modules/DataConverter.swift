//
//  DataConverter.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/3/23.
//

import Foundation

struct DataConverter {
    
    static func convertToFriendEntity(displayName: String, friendUserID: String, friendCodeID: String, profileImageString: String, isFavorite: Bool, isFriend: Bool) -> FriendEntity {
        let newFriend = FriendEntity()
        newFriend.friendCodeID = friendCodeID
        newFriend.id =  friendUserID
        newFriend.displayName = displayName
        newFriend.isFriend = isFriend
        newFriend.isFavorite = isFavorite
        newFriend.imageString = profileImageString
        return newFriend
    }
    
}