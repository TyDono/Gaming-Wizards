//
//  MessengerProfileView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/14/23.
//

import SwiftUI

struct MessengerProfileView: View {
    @Binding var profileImageString: String
    @StateObject private var messengerProfileVM = MessengerProfileViewModel()
    
    var body: some View {
        messengerProfileImage
    }
    
    private var messengerProfileImage: some View {
        VStack {
            Image(uiImage: messengerProfileVM.profileImage ?? UIImage(named: Constants.wantedWizardPlusImageString)!)
            // change these two aspects later on. to what? idk. fit in the circle a lil bit.
                .resizable()
                .aspectRatio(contentMode: .fit)
            
                .font(.system(size: 32))
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke( .black,
                             lineWidth: 1)
                )
//                .scaledToFit()
                .frame(width: 52, height: 52)
        }
        .task {
            messengerProfileVM.callRetrieveProfileImageFromDisk(imageString: profileImageString)
        }
    }
    
}

struct MessengerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MessengerProfileView(profileImageString: .constant("nuphing"))
    }
}
