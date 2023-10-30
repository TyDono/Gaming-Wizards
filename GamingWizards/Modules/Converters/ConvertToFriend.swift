//
//  ConvertUserToFriend.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/27/23.
//

import Foundation
import Firebase

struct ConvertToFriend {
    
    func convertUserToFriend(user: User) -> Friend {
        
        let friendData: [String: Any] = [
            Constants.idStringValue: user.id,
            Constants.displayName: user.displayName,
            Constants.isFriend: false,
            Constants.isFavorite: false,
            Constants.imageString: user.profileImageString,
            Constants.recentMessageText: "",
            Constants.recentMessageTimeStamp: Timestamp(date: Date()),
            Constants.onlineStatus: false,
            Constants.messageToId: ""
        ]
        let friend = Friend(data: friendData)
        return friend
    }
    
    func convertUserObservableToFriend(userObservable: UserObservable) -> Friend {
        
        let friendData: [String: Any] = [
            Constants.idStringValue: userObservable.id,
            Constants.displayName: userObservable.displayName,
            Constants.isFriend: false,
            Constants.isFavorite: false,
            Constants.imageString: userObservable.profileImageString,
            Constants.recentMessageText: "",
            Constants.recentMessageTimeStamp: Timestamp(date: Date()),
            Constants.onlineStatus: false,
            Constants.messageToId: ""
        ]
        let friend = Friend(data: friendData)
        return friend
    }

    
}
