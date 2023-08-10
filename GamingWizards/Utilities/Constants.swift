//
//  Constants.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/7/22.
//

//import Foundation
import SwiftUI

struct Constants {
    static var isFriendRequestPending: Bool = false // not used rn. using friendRequestCount instead. shows number, or if it's 0. shows nothing
    static var friendRequestCount: Int = 0
    static let luminariRegularFontIdentifier = "Luminari"
    static var semiRoundedCornerRadius: CGFloat = 8
    static var roundedCornerRadius: CGFloat = 32
    static var buttonShadowRadius: CGFloat = 15
    static var tagFlowLayoutCornerRadius: CGFloat = 18
    static let usersString = "users"
    static let textFieldMaxCharacters: Int = 45
    static let textViewMaxCharacters: Int = 500
    static let navigationTitleFontSize: Int = 26
    static let profileImageWidth: CGFloat = 300
    static let profileImageHeight: CGFloat = 300
    static let wantedWizardImageString = "WantedWizard"
    static let wantedWizardPlusImageString = "WantedWizard+"
    
    // MARK: calls to Tab
    static let accountTabViewString = "Account"
    static let searchTabViewString = "Search"
    static let messageTabViewString = "TabViewString"
    static let mapTabViewString = "Map"
    
    // MARK: calls to User
    static let userFriendCodeID = "friendCodeID"
    static let userID = "id"
    static let userFirstName = "firstName"
    static let userLastName = "lastName"
    static let userDisplayName = "displayName"
    static let userEmail = "email"
    static let userLocation = "location"
    static let userProfileImageString = "profileImageString"
    static let userFriendList = "friendList"
    static let userFriendRequest = "friendRequest"
    static let userListOfGamesString = "listOfGames"
    static let userGroupSize = "groupSize"
    static let userAge = "age"
    static let userAbout = "about"
    static let userAvailability = "availability"
    static let userTitle = "title"
    static let userPayToPlay = "isPayToPlay"
    static let userIsSolo = "isSolo"
    
    // MARK: calls to AppStorage
//    static let appStorageStringUserId = "user_Id"
//    static let appStorageStringUserFirstName = "user_First_Name"
//    static let appStorageStringUserLastName = "user_Last_Name"
//    static let appStorageStringUserDisplayName = "user_Display_Name"
//    static let appStorageStringUserEmail = "user_Email"
//    static let appStorageStringUserLocation = "user_Location"
//    static let appStorageStringUserProfileImageString = "user_Profile_Image_String"
//    static let appStorageStringUserFriendCodeID = "user_Friend_Code_ID"
//    static let appStorageStringUserGames = "user_Games"
//    static let appStorageStringUserGroupSize = "user_Group_Size"
//    static let appStorageStringUserAge = "user_Age"
//    static let appStorageStringUserAbout = "user_About"
//    static let appStorageStringUserAvailability = "user_Availability"
//    static let appStorageStringUserTitle = "user_Title"
//    static let appStorageStringUserIsPayToPlay = "user_Is_Pay_To_play"
//    static let appStorageStringUserIsSolo = "user_Is_Solo"
    
    static let appStorageStringLogStatus = "log_Status"
    
    // MARK: calls to Friend
    static let friendCodeID = "friendCodeID"
    static let friendUserID = "id"
    static let displayName = "displayName"
    static let isFriend = "isFriend"
    static let isFavorite = "isFavorite"
    static let imageString = "imageString"
    
    // MARK: call to UserReport
    static let reportReason = "reason"
    static let reportCreatorID = "creatorID"
    static let reportChatID = "chatID"
    static let reportDateSent = "dateSent"
    static let reportID = "id"
    static let reportUserReportedID = "userReportedID"
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
