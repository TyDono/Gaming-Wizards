//
//  ViewPersonalAccountView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.

import SwiftUI
import PhotosUI

struct ViewPersonalAccountView: View {
//    @ObservedObject var user: UserObservable
    @StateObject var viewPersonalAccountViewModel: ViewPersonalAccountViewModel
    @Environment(\.dismiss) var dismiss
    @State var editAccountViewIsPresented: Bool = false
    @Binding var isShowingEditAccountView: Bool

    init(
//        user: UserObservable = UserObservable.shared,
        viewPersonalAccountViewModel: ViewPersonalAccountViewModel = ViewPersonalAccountViewModel(user: UserObservable.shared),
        isShowingEditAccountView: Binding<Bool>
    ) {
//        self._user = ObservedObject(wrappedValue: user)
        self._viewPersonalAccountViewModel = StateObject(wrappedValue: viewPersonalAccountViewModel)
        self._isShowingEditAccountView = isShowingEditAccountView
    }
    
    var body: some View {
        ZStack {
//            self.backgroundImage
            VStack {
                accountView
                    .padding()
                editPersonalAccountButtonView
                    .padding()
            }
        }
        .background(
            backgroundImage
        )
//        .font(.globalFont(.luminari, size: 16))
        .font(.roboto(.regular, size: 16))
    }
    
    private var backgroundImage: some View {
        Color.clear
        /*
        Image("blank-page")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
         */
    }
    
    private var editPersonalAccountButtonView: some View {
        Button(action: {
            dismiss()
            isShowingEditAccountView = true
        }) {
            HStack {
                Text("Edit Account")
//                    .font(.globalFont(.luminari, size: 21))
                    .font(.roboto(.regular, size: 21))
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(.blue)
            .cornerRadius(Constants.roundedCornerRadius)
            .padding(.horizontal)
            .shadow(radius: Constants.buttonShadowRadius)
            
        }
    }
    
    private var accountView: some View {
        AccountView(displayName: $viewPersonalAccountViewModel.user.displayName, userLocation: $viewPersonalAccountViewModel.user.location, profileImageString: $viewPersonalAccountViewModel.user.profileImageString, profileImage: $viewPersonalAccountViewModel.profileImage, listOfGames: $viewPersonalAccountViewModel.user.listOfGames, groupSize: $viewPersonalAccountViewModel.user.groupSize, age: $viewPersonalAccountViewModel.user.age, about: $viewPersonalAccountViewModel.user.about, title: $viewPersonalAccountViewModel.user.title, availability: $viewPersonalAccountViewModel.user.availability, isPayToPlay: $viewPersonalAccountViewModel.user.isPayToPlay, isUserSolo: $viewPersonalAccountViewModel.user.isSolo)
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
