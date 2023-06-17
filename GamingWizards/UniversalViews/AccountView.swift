//
//  AccountView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.
//

import SwiftUI

struct AccountView: View {
//    @Binding var isShowingAccountView: Bool?
//    @Binding var isShowingEditAccountView: Bool?
    
    @Binding var firstName: String?
    @Binding var lastName: String?
    @Binding var displayName: String?
//    @Binding var email: String?
    @Binding var userLocation: String?
    @Binding var profileImageString: String?
    @Binding var profileImage: UIImage?
    @Binding var friendCodeId: String?
    @Binding var listOfGames: [String?]
    @Binding var groupSize: String?
    @Binding var age: Int?
    @Binding var about: String?
    @Binding var title: String?
    @Binding var isPayToPlay: Bool?
    @Binding var isUserSolo: Bool?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}
