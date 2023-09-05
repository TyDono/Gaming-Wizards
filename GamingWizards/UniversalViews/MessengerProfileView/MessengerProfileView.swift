//
//  MessengerProfileView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/14/23.
//

import SwiftUI

struct MessengerProfileView: View {
    @Binding var profileImageString: String
    @StateObject private var messengerProfileVM: MessengerProfileViewModel
    
    init(profileImageString: Binding<String>) {
        self._profileImageString = profileImageString
        let profileString = profileImageString.wrappedValue
        self._messengerProfileVM = StateObject(wrappedValue: MessengerProfileViewModel( profileImageString: profileString))
    }
    
    var body: some View {
        messengerProfileImage
    }
    
    private var messengerProfileImage: some View {
        VStack {
            if let profileImage = messengerProfileVM.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: 32))
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(.black, lineWidth: 1)
                    )
                    .frame(width: 52, height: 52)
            } else {
                Text("Loading...")
            }
        }
    }
}


struct MessengerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let profileImageBinding = Binding<String>(
            get: { "nuphing" }, 
            set: { _ in }
        )
        
        return MessengerProfileView(profileImageString: profileImageBinding)
    }
}
