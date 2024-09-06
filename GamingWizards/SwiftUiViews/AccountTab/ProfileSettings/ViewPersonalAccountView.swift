//
//  ViewPersonalAccountView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.

import SwiftUI
import PhotosUI

struct ViewPersonalAccountView: View {
    @StateObject var viewPersonalAccountViewModel: ViewPersonalAccountViewModel
    @Environment(\.dismiss) var dismiss
    @State var editAccountViewIsPresented: Bool = false
    @Binding var isShowingEditAccountView: Bool

    init(
        viewPersonalAccountViewModel: ViewPersonalAccountViewModel = ViewPersonalAccountViewModel(user: UserObservable.shared),
        isShowingEditAccountView: Binding<Bool>
    ) {
        self._viewPersonalAccountViewModel = StateObject(wrappedValue: viewPersonalAccountViewModel)
        self._isShowingEditAccountView = isShowingEditAccountView
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    accountView
                        .padding()
                }
            }
            .background(backgroundImage)
            .font(.roboto(.regular, size: 16))
            // Use navigationDestination to navigate to ManageAccountView when isShowingEditAccountView is true
            .navigationDestination(isPresented: $isShowingEditAccountView) {
                ManageAccountView()
            }
        }
    }

    private var backgroundImage: some View {
        Color.clear
    }

    private var editPersonalAccountButtonView: some View { // Not used
        Button(action: {
//            dismiss()
            isShowingEditAccountView = true
        }) {
            HStack {
                Text("Edit Account")
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
        AccountView(
            displayName: $viewPersonalAccountViewModel.user.displayName,
            userLocation: $viewPersonalAccountViewModel.user.location,
            profileImageString: $viewPersonalAccountViewModel.user.profileImageString,
            profileImage: $viewPersonalAccountViewModel.profileImage,
            listOfGames: $viewPersonalAccountViewModel.user.listOfGames,
            groupSize: $viewPersonalAccountViewModel.user.groupSize,
            age: $viewPersonalAccountViewModel.user.age,
            about: $viewPersonalAccountViewModel.user.about,
            title: $viewPersonalAccountViewModel.user.title,
            availability: $viewPersonalAccountViewModel.user.availability,
            isPayToPlay: $viewPersonalAccountViewModel.user.isPayToPlay,
            isUserSolo: $viewPersonalAccountViewModel.user.isSolo
        )
        .onAppear {
            viewPersonalAccountViewModel.retrieveProfileImageFromDisk()
        }
    }
}
