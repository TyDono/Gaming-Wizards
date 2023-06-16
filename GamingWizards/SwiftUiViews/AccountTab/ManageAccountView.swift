//
//  SettingsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/27/22.
//

import SwiftUI
import Combine
import PhotosUI

struct ManageAccountView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject private var manageAccountViewModel = ManageAccountViewModel()
//    @ObservedObject var user = UserObservable()
    
//    let session: SessionStore
    
//    init(viewModel: ManageAccountViewModel) {
//        self.manageAccountViewModel = viewModel
//    }
    
    var body: some View {
            ZStack(alignment: .bottom) {

                VStack {
                    ScrollView {
                        
                        Group {
                            profileImageView
                                .padding()
                            personalTitleView
                                .padding()
                            displayNameTextField
                                .padding()
                            firstNameTextField
                                .padding()
                            lastNameTextField
                                .padding()
                            aboutUserTextView
                                .padding()
                            userAvailabilityTextView
                                .padding()
                        }
                        Group {
                            userIsSoloView
                                .padding()
                            userAgeTextView
                                .padding()
                            userLocationTextView
                                .padding()
                            PayToPlayView
                                .padding()
                            personalFriendID
                                .padding()
                            emailTextField
                                .padding()
                            VStack {
                                deleteAccountButton
                                    .padding()
                            }
                        }
                    
                    }
                }
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                if manageAccountViewModel.isProfileUploading {
                    LoadingAnimation(loadingProgress: $manageAccountViewModel.uploadProfileProgress)
                }
            }
            .navigationBarTitle("Manage Account", displayMode: .inline)
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
                    .onChange(of: manageAccountViewModel.profileImage, perform: { newValue in
                        manageAccountViewModel.didProfileImageChange = true
                        manageAccountViewModel.isSaveChangesButtonIsActive = true
                    })
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
        .sheet(isPresented: $manageAccountViewModel.isShowingImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $manageAccountViewModel.profileImage)
        }
    }
    
    private var userIsSoloView: some View {
        VStack {
            Text(manageAccountViewModel.userIsSolo ? "Solo" : "Group")
            
            Toggle(isOn: $manageAccountViewModel.userIsSolo) {
            }
            .onChange(of: manageAccountViewModel.userIsSolo) { newValue in
                manageAccountViewModel.isSaveChangesButtonIsActive = true
            }
        } .onAppear {
//            manageAccountViewModel.isPayToPlay = manageAccountViewModel.user_Is_Solo ?? false
        }
    }
    
    private var personalTitleView: some View {
        VStack {
            Text("Title")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
            TextField("",
                      text: $manageAccountViewModel.userTitle.max(Constants.textFieldMaxCharacters),
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
            manageAccountViewModel.userTitle = manageAccountViewModel.user.title ?? ""
        }
    }
    
    // user's will know it as their personal ID, but on code it is their FriendID. their real ID is a uuid.
    private var personalFriendID: some View {
        VStack {
            Text("Friend ID")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 15))
            Text("\(manageAccountViewModel.user.friendCodeID ?? "")")
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
                      text: $manageAccountViewModel.displayName.max(Constants.textFieldMaxCharacters),
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
            manageAccountViewModel.displayName = manageAccountViewModel.user.displayName ?? ""
        }
    }
    
    private var userAgeTextView: some View {
        VStack {
            Text("Age")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
            TextField("",
                      text: $manageAccountViewModel.userAge.max(Constants.textFieldMaxCharacters),
                      onEditingChanged: { changed in
                manageAccountViewModel.isSaveChangesButtonIsActive = true
                        })
            .keyboardType(.numberPad)
            .onReceive(Just(manageAccountViewModel.userAge)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.manageAccountViewModel.userAge = filtered
                }
            }
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
            manageAccountViewModel.age = manageAccountViewModel.user.age ?? 0
        }
    }
    
    private var userLocationTextView: some View {
        VStack {
            Text("Location")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
            TextField("",
                      text: $manageAccountViewModel.userLocation.max(Constants.textFieldMaxCharacters),
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
            manageAccountViewModel.userLocation = manageAccountViewModel.user.location ?? ""
        }
    }
    
    private var userAvailabilityTextView: some View {
        VStack {
            Text("Availability")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
            TextField("",
                      text: $manageAccountViewModel.userAvailability.max(Constants.textFieldMaxCharacters),
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
            manageAccountViewModel.userAvailability = manageAccountViewModel.user.availability ?? ""
        }
    }
    
    private var PayToPlayView: some View {
        VStack {
            Text(manageAccountViewModel.isPayToPlay ? "Pay to Play" : "Free to Play")
            
            Toggle(isOn: $manageAccountViewModel.isPayToPlay) {
//                Text("Switch")
            }
            .onChange(of: manageAccountViewModel.isPayToPlay) { newValue in
                manageAccountViewModel.isSaveChangesButtonIsActive = true
            }
        } .onAppear {
            manageAccountViewModel.isPayToPlay = manageAccountViewModel.user.isPayToPlay ?? false
        }
    }
    
    private var aboutUserTextView: some View {
        VStack {
            if manageAccountViewModel.about.isEmpty == true {
                Text("Write about yourself")
                    .foregroundColor(.gray)
            }
            
            TextEditor(text: $manageAccountViewModel.about.max(Constants.textViewMaxCharacters))
                .border(Color.gray, width: 1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: manageAccountViewModel.about) { newValue in
                    manageAccountViewModel.isSaveChangesButtonIsActive = true
                }
        }
        .padding()
        .onAppear {
            manageAccountViewModel.about = manageAccountViewModel.user.about ?? ""
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
                      text: $manageAccountViewModel.firstName.max(Constants.textFieldMaxCharacters),
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
            manageAccountViewModel.firstName = manageAccountViewModel.user.firstName ?? ""
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
                      text: $manageAccountViewModel.lastName.max(Constants.textFieldMaxCharacters),
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
            manageAccountViewModel.lastName = manageAccountViewModel.user.lastName ?? ""
        }
    }
    
    private var emailTextField: some View {
        VStack {
            Text("Email")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 15))
            Text("\(manageAccountViewModel.user.email ?? "")")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 21))
            
            //used for the future when user can change their email
//                        Text("Email")
//                            .frame(maxWidth: .infinity,
//                                   alignment: .leading)
//                            .font(.roboto(.semibold,
//                                          size: 18))
//                        TextField("",
//                                  text: $manageAccountViewModel.email,
//                                  onEditingChanged: { changed in
//                            manageAccountViewModel.isSaveChangesButtonIsActive = true
//                            //this also needs to have a check for email existing
//                                    })
//                        .padding(.horizontal, 15)
//                        .frame(height: 40.0)
//                        .background(Colors.textFieldGrey)
//                        .background(RoundedRectangle(cornerRadius: 30))
//                        .keyboardType(.emailAddress)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.gray.opacity(0.80),
//                                        lineWidth: 1)
//                        )
            
        } //.onAppear {
           // guard let email = manageAccountViewModel.user_Email else { return }
           // manageAccountViewModel.displayName = email
        //}
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
//                .padding(.top, 15)
//                .padding(.trailing, 25)
        }
        .disabled(manageAccountViewModel.isSaveChangesButtonIsActive == false)
        .alert(isPresented: $manageAccountViewModel.accountInformationSavedAlertIsActive) {
            Alert(
                title: Text("Account Info Saved"),
                dismissButton: .default(Text("Ok")) {
                }
                
            )
        }

//            .modifier(isSaveChangesButtonIsActive ? FontModifier(size: 14, weight: .extraBold) : FontModifier(size: 14, weight: .regular))
        
    }
    
    func signOut() {
//        presentationMode.wrappedValue.dismiss()
        authenticationViewModel.signOut()
    }
    
}
struct ManageAccountView_Previews: PreviewProvider {
    static var previews: some View {
        
        ManageAccountView()
    }
}
