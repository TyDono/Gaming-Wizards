//
//  ViewPersonalAccountView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.
//

import SwiftUI

//
//  SettingsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/27/22.
//

import SwiftUI
import PhotosUI

struct ViewPersonalAccountView: View {
    @ObservedObject var user = UserObservable.shared
    @StateObject var viewPersonalAccountViewModel = ViewPersonalAccountViewModel()
    @Environment(\.dismiss) var dismiss
//    Environment(\.presentationMode) var presentationMode
    @State var editAccountViewIsPresented: Bool = false
    @Binding var isShowingEditAccountView: Bool
    
    var body: some View {
        ZStack {
            self.backgroundImage
            VStack {
                accountView
                    .padding()
                editPersonalAccountButtonView
                    .padding()
            }
        }
        .navigationTitle(user.title ?? "")
        .font(.globalFont(.luminari, size: 16))
//        .background(backgroundImage)
    }
    
    private var backgroundImage: some View {
        Image("blank-page")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
    private var editPersonalAccountButtonView: some View {
        Button(action: {
            dismiss()
            isShowingEditAccountView = true
        }) {
            Text("Edit Account")
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .background(.clear)
                        .foregroundColor(.blue)
                        .padding(
                            EdgeInsets(
                                top: -10,
                                leading: -10,
                                bottom: -10,
                                trailing: -10
                            )
                        )
                )
        }
    }
    
    private var accountView: some View {
        AccountView(displayName: $user.displayName, userLocation: $user.location, profileImageString: $user.profileImageString, profileImage: $viewPersonalAccountViewModel.profileImage, friendCodeId: $user.friendCodeID, listOfGames: $user.listOfGames, groupSize: $user.groupSize, age: $user.age, about: $user.about, title: $user.title, availability: $user.availability, isPayToPlay: $user.isPayToPlay, isUserSolo: $user.isSolo)
            .onAppear {
                viewPersonalAccountViewModel.retrieveProfileImageFromDisk()
            }
    }
}


struct ViewPersonalAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPersonalAccountView(isShowingEditAccountView: .constant(false))
    }
}
