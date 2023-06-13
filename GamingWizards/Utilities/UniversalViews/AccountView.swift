//
//  AccountView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.
//

import SwiftUI

struct AccountView: View {
    @Binding var firstName: String?
    @Binding var lastName: String?
    @Binding var displayName: String?
//    @Binding var email: String?
    @Binding var userLocation: String?
    @Binding var profileImageString: String?
    @Binding var friendCodeId: String?
    @Binding var gameList: [ListOfGames?]
    @Binding var groupSize: String?
    @Binding var age: String?
    @Binding var about: String?
    @Binding var title: String?
    @Binding var isPayToPlay: Bool?
    @Binding var isUserSolo: Bool?
    
    /*
     @AppStorage(Constants.appStorageStringUserFirstName) var first_Name: String?
     @AppStorage(Constants.appStorageStringUserLastName) var last_Name: String?
     @AppStorage(Constants.appStorageStringUserDisplayName) var display_Name: String?
     @AppStorage(Constants.appStorageStringUserEmail) var user_Email: String?
     @AppStorage(Constants.userLocation) var user_Location: String?
     @AppStorage(Constants.appStorageStringUserProfileImageString) var profile_Image_String: String?
     @AppStorage(Constants.appStorageStringUserFriendCodeID) var user_Friend_Code_ID: String?
     @AppStorage(Constants.appStorageStringUserGames) var user_Games: String?
     @AppStorage(Constants.appStorageStringUserGroupSize) var user_Group_Size: String?
     @AppStorage(Constants.userAge) var user_Age: String?
     @AppStorage(Constants.appStorageStringUserAbout) var about_user: String?
     @AppStorage(Constants.appStorageStringUserAvailability) var user_Availability: String?
     @AppStorage(Constants.appStorageStringUserTitle) var user_title: String?
     @AppStorage(Constants.appStorageStringUserIsPayToPlay) var user_PayTo_Play: Bool?
     @AppStorage(Constants.appStorageStringUserIsSolo) var user_Is_Solo: Bool?
     */
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}
