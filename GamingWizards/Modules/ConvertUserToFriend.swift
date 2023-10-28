//
//  ConvertUserToFriend.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/27/23.
//

import Foundation
import Firebase

struct ConvertUserToFriend {
    
    func convertUserToFriend(user: User) -> Friend {
        let friend = Friend(
            id: user.id,
            displayName: user.displayName ?? "",
            isFriend: false,
            isFavorite: false,
            imageString: user.profileImageString,
            recentMessageText: "",
            recentMessageTimeStamp: Timestamp(),
            onlineStatus: false,
            messageToId: ""
        )
        return friend
    }
    
    func convertUserObservableToFriend(userObservable: UserObservable) -> Friend {
        /*
        let user = User(
            id: userObservable.id,
            firstName: userObservable.firstName,
            lastName: userObservable.lastName,
            displayName: userObservable.displayName,
            email: userObservable.email,
            latitude: userObservable.latitude,
            longitude: userObservable.longitude,
            location: userObservable.location,
            profileImageString: userObservable.profileImageString,
            listOfGames: userObservable.listOfGames,
            groupSize: userObservable.groupSize,
            age: userObservable.age,
            about: userObservable.about,
            availability: userObservable.availability,
            title: userObservable.title,
            isPayToPlay: userObservable.isPayToPlay,
            isSolo: userObservable.isSolo,
            deviceInfo: userObservable.deviceInfo,
            dateFirstInstalled: userObservable.dateFirstInstalled
        )
        */
        let friend = Friend(
            id: userObservable.id,
            displayName: userObservable.displayName ?? "",
            isFriend: false,
            isFavorite: false,
            imageString: userObservable.profileImageString,
            recentMessageText: "",
            recentMessageTimeStamp: Timestamp(),
            onlineStatus: false,
            messageToId: ""
        )

        return friend
    }

    
}
