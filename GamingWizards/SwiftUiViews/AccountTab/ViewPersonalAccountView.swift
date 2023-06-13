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
import Combine
import PhotosUI

struct ViewPersonalAccountView: View {
    var body: some View {
        Text("tim")
    }
    /*
    @Environment(\.presentationMode) var presentationMode
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
    @StateObject private var viewPersonalAccountViewModel = ViewPersonalAccountViewModel()
    var body: some View {
            ZStack(alignment: .bottom) {

                VStack {
                    List {
                        profileImageView
                        displayNameTextField
                        firstNameTextField
                        lastNameTextField
                        aboutUserTextView
                        personalFriendID
                        emailTextField
                        VStack {
                            deleteAccountButton
                        }
                    }
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
            .navigationBarTitle(viewPersonalAccountViewModel, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveChangesNavButton
                }
            }
        
            .alert(isPresented: $manageAccountViewModel.accountInformationChangedErrorAlertIsActive) {
                Alert(
                    title: Text("Error in Saving"),
                    message: Text("There was an error saving your changes. Please check your internet connection and try again"),
                    dismissButton: .default(Text("Ok")) {
                    }
                )
            }

    }
    
    private var profileImageView: some View {
        VStack {
            Spacer()
            if let profileImage = manageAccountViewModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .onChange(of: manageAccountViewModel.profileImage, perform: { newValue in
                        manageAccountViewModel.didProfileImageChange = true
                        manageAccountViewModel.isSaveChangesButtonIsActive = true
                    })
                    .onTapGesture {
                        manageAccountViewModel.isShowingImagePicker = true
                    }
            } else {
                Image("WantedWizard+")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .onTapGesture {
                        manageAccountViewModel.isShowingImagePicker = true
                    }
            }
            Button(action: {
                manageAccountViewModel.isShowingImagePicker = true
            }) {
                Text("Change image")
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.blue)
                    .cornerRadius(5)
            }
        }
        
        .onAppear {
            manageAccountViewModel.loadProfileImageFromDisk()
        }

//        .onTapGesture {
//            manageAccountViewModel.isShowingImagePicker = true
//        }
        .sheet(isPresented: $manageAccountViewModel.isShowingImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $manageAccountViewModel.profileImage)
        }
//        .onChange(of: manageAccountViewModel.profileImage) { newValue in
//            manageAccountViewModel.isSaveChangesButtonIsActive = true
//        }
//        .onChange(of: manageAccountViewModel.inputProfileImage) { _ in manageAccountViewModel.loadImage }
    }
    
    // user's will know it as their personal ID, but on code it is their FriendID. their real ID is a uuid.
    private var personalFriendID: some View {
        VStack {
            Text("Friend ID")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 15))
            Text("\(manageAccountViewModel.user_Friend_Code_ID ?? "")")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 21))
        }
    }
    
    private var displayNameTextField: some View {
        VStack {
            Text("Display Name")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
            TextField("",
                      text: $manageAccountViewModel.displayName,
                      onEditingChanged: { changed in
                manageAccountViewModel.isSaveChangesButtonIsActive = true
                        })
            .padding(.horizontal, 15)
            .frame(height: 40.0)
            .background(Colors.textFieldGrey)
            .background(RoundedRectangle(cornerRadius: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.80),
                            lineWidth: 1)
            )
        } .onAppear {
            manageAccountViewModel.displayName = manageAccountViewModel.display_Name ?? ""
        }
    }
    
    private var aboutUserTextView: some View {
        VStack {
            if manageAccountViewModel.about.isEmpty == true {
                Text("Write about yourself")
                    .foregroundColor(.gray)
            }
            
            TextEditor(text: $manageAccountViewModel.about)
                .border(Color.gray, width: 1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: manageAccountViewModel.about) { newValue in
                    manageAccountViewModel.isSaveChangesButtonIsActive = true
                }
        }
        .padding()
        .onAppear {
            manageAccountViewModel.about = manageAccountViewModel.about_user ?? ""
        }
        
    }
    
    private var firstNameTextField: some View { //not implemented
        VStack {
            Text("First Name")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
            TextField("",
                      text: $manageAccountViewModel.firstName,
                      onEditingChanged: { changed in
                manageAccountViewModel.isSaveChangesButtonIsActive = true
                        })
            .padding(.horizontal, 15)
            .frame(height: 40.0)
            .background(Colors.textFieldGrey)
            .background(RoundedRectangle(cornerRadius: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.80),
                            lineWidth: 1)
            )
        }.onAppear {
            manageAccountViewModel.firstName = manageAccountViewModel.first_Name ?? ""
        }
    }
    
    private var lastNameTextField: some View { // not implemented
        VStack {
            Text("Last Name")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
            TextField("",
                      text: $manageAccountViewModel.lastName,
                      onEditingChanged: { changed in
                manageAccountViewModel.isSaveChangesButtonIsActive = true
                        })
            .padding(.horizontal, 15)
            .frame(height: 40.0)
            .background(Colors.textFieldGrey)
            .background(RoundedRectangle(cornerRadius: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.80),
                            lineWidth: 1)
            )
        }.onAppear {
            manageAccountViewModel.lastName = manageAccountViewModel.last_Name ?? ""
        }
    }
    
    private var emailTextField: some View {
        VStack {
            Text("Email")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 15))
            Text("\(manageAccountViewModel.user_Email ?? "")")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 21))
        }
    }
    
    private var customNavigationBar: some View { // not called anywhere
        ZStack {
            HStack {
                backButton
                Spacer()
                saveChangesNavButton
            }
        }
    }
    
    private var deleteAccountButton: some View {
        Button(action: {
            manageAccountViewModel.deleteUserAccount()
        }) {
            Text("Delete Account")
                .foregroundColor(.red)
            
        }
        .alert(isPresented: $manageAccountViewModel.accountDeleteErrorAlertIsShowing) {
            Alert(
                title: Text("Error in Deletion"),
                message: Text("You must re-sign in to re-authenticate your account before deletion"),
                primaryButton: .default(Text("Sign Out?")) {
                    authenticationViewModel.signOut()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .frame(width: 15,
                       height: 15)
                .foregroundColor(.black)
                .padding(.top, 15)
                .padding(.leading, 25)
        }
    }
    
    private var saveChangesNavButton: some View {
        Button {
            manageAccountViewModel.updateUserInfo()
        } label: {
            Text("Save")
                .foregroundColor(manageAccountViewModel.isSaveChangesButtonIsActive ? Colors.black70 : Colors.lightGreyTwo)
                .fontWeight(.black)
                .foregroundColor(Color(.systemIndigo))
                .multilineTextAlignment(.center)
        }
        .disabled(manageAccountViewModel.isSaveChangesButtonIsActive == false)
        .alert(isPresented: $manageAccountViewModel.accountInformationSavedAlertIsActive) {
            Alert(
                title: Text("Account Info Saved"),
                dismissButton: .default(Text("Ok")) {
                }
                
            )
        }
        
    }
    */
}


struct ViewPersonalAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPersonalAccountView()
    }
}
