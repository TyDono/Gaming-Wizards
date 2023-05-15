//
//  Constants.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation
import SwiftUI

struct Constants {
    static var isFriendRequestPending: Bool = false // not used rn. using friendRequestCount instead. shows number, or if it's 0. shows nothing
    static var friendRequestCount: Int = 0
    static let luminariRegularFontIdentifier = "Luminari"
    static let users = "users"
    
    // MARK: calls to User
    static let userFriendCode = "friendCode"
    static let userID = "id"
    static let userDisplayName = "displayName"
    static let userEmail = "email"
    static let userLocation = "location"
    static let userProfileImageURL = "profileImageURL"
    static let userFriendID = "friendID"
    static let userFriendList = "friendList"
    static let userFriendRequest = "friendRequest"
    static let userGames = "games"
    static let userGroupSize = "groupSize"
    static let userAge = "age"
    static let userAbout = "about"
    static let userAvailability = "availability"
    
    // MARK: calls to Friend
    static let friendCodeID = "friendCodeID"
    static let friendUserID = "friendUserID"
    static let friendDisplayName = "friendDisplayName"
    static let isFriend = "isFriend"
    static let isFavorite = "isFavorite"
    
    // MARK: call to UserReport
    static let reportReason = "reason"
    static let reportCreatorID = "creatorID"
    static let reportChatID = "chatID"
    static let reportDateSent = "dateSent"
    static let reportID = "id"
    static let reportUserReportedID = "userReportedID"
    
//    var firstName = ""
//    var lastName = ""
//    var displayName = ""
//    var email: String? = ""
//    var location: String = "" //change to UserLocation later date maybe
//    var profileImageUrl = ""
//    var friendID = ""
//    var friendList: [Friend] = [] // sub collection
//    var friendRequests: [Friend] = [] // sub collection
//    var games: [String] = []
//    var groupSize: String = ""
//    var age: String = ""
//    var about: String = ""
//    var availability: String = ""
}

enum Colors {
    static let green = Color(red: 2/255, green: 97/255, blue: 104/255)
    static let greenDark = Color(red: 2/255, green: 61/255, blue: 79/255)
    static let green35 = Color(red: 2/255, green: 97/255, blue: 104/255).opacity(0.35)
    static let turtleGreen = Color(red: 129/255, green: 192/255, blue: 84/255)
    
    static let textFieldGrey = Color(red: 239/255, green: 243/255, blue: 244/255)
    static let greyLight = Color(red: 239/255, green: 239/255, blue: 239/255)
    static let greyMedium = Color(red: 155/255, green: 155/255, blue: 155/255)
    static let greyDark = Color(red: 74/255, green: 74/255, blue: 74/255)
    static let lightGreyTwo = Color(red: 219/255, green: 219/255, blue: 219/255)
    static let lightGreyThree = Color(red: 210/255, green: 210/255, blue: 210/255)
    static let lightGreyFour = Color(red: 245/255, green: 245/255, blue: 245/255)
    
    static let darkGreyTwo = Color(red: 44/255, green: 44/255, blue: 46/255)
    static let darkGreyThree = Color(red: 183/255, green: 183/255, blue: 190/255)
    static let darkGreyFour = Color(red: 105/255, green: 105/255, blue: 105/255)
    
    static let error = Color(red: 208/255, green: 2/255, blue: 27/255)
    static let red10 = Color(red: 255/255, green: 0/255, blue: 0/255).opacity(0.1)
    static let redLight = Color(red: 226/255, green: 108/255, blue: 123/255)
    
    static let GamingWizardsBrown = Color(red: 166/255, green: 113/255, blue: 0/255)
    static let GamingWizardsYellow = Color(red: 255/255, green: 209/255, blue: 0/255)
    
    static let black70 = Color(red: 0/255, green: 0/255, blue: 0/255).opacity(0.7)
    static let black26 = Color(red: 0/255, green: 0/255, blue: 0/255).opacity(0.26)
    static let black16 = Color(red: 0/255, green: 0/255, blue: 0/255).opacity(0.16)
}

enum AnalyticsEvents {
    
    static let signUpWithGoogle = "sign_up_with_google"
    static let signUpWithApple = "sign_up_with_apple"
    
    static let logInWithGoogle = "log_in_with_google"
    static let logInWithApple = "log_in_with_apple"
    
}
