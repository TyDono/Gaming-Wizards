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
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
    @StateObject private var manageAccountVM = ManageAccountViewModel()
//    @StateObject private var filterer = Filterer()
    @State private var isKeyboardVisible = false

    
//    let session: SessionStore
    
//    init(viewMod  el: ManageAccountViewModel) {
//        self.manageAccountViewModel = viewModel
//    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                ScrollView {
                    Group {
                        profileImageView
                            .padding()
                        Divider()
                        manageListOfGamesButtonView
                            .padding()
                        Divider()
                        personalTitleView
                            .padding()
                        Divider()
                    }
                    Group {
                        displayNameTextField
                            .padding()
                        Divider()
                        userAgeTextView
                            .padding()
                        Divider()
                        userLocation
                            .padding()
                        Divider()
                    }
                    Group {
                        aboutUserTextView
                            .padding()
                        Divider()
                        userAvailabilityTextView
                            .padding()
                        Divider()
                        userIsSoloView
                            .padding()
                        Divider()
                        PayToPlayView
                            .padding()
                        Divider()
                    }
                    Group {
                        Divider()
                        emailTextField
                            .padding()
                        Divider()
                        VStack {
                            deleteAccountButton
                                .padding()
                        }
                    }
                }
                .padding(.bottom, 80)
                .scrollDismissesKeyboard(.automatic)
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom) // Only ignore bottom safe area to accommodate keyboard if needed
            if manageAccountVM.isProfileUploading {
                LoadingAnimation(loadingProgress: $manageAccountVM.uploadProfileProgress)
            }
        }
        .navigationBarTitle("Manage Account", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                saveChangesNavButton
            }
        }
        .alert(isPresented: $manageAccountVM.accountInformationChangedErrorAlertIsActive) {
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
            Image(uiImage: (manageAccountVM.profileImage ?? UIImage(named: Constants.wantedWizardPlusImageString))!)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.profileImageWidth, height: Constants.profileImageHeight)
                .onChange(of: manageAccountVM.profileImage, perform: { newValue in
                })
                .onTapGesture {
                    manageAccountVM.userChangedImage()
                }
            Button(action: {
                manageAccountVM.userChangedImage()
            }) {
                Text("Change image")
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.blue)
                    .cornerRadius(Constants.semiRoundedCornerRadius)
                    .shadow(radius: Constants.buttonShadowRadius)

            }
        }
        .onAppear(perform: manageAccountVM.retrieveProfileImageFromDisk)
        .sheet(isPresented: $manageAccountVM.isShowingImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $manageAccountVM.profileImage)
        }
    }
    
    private var userIsSoloView: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: manageAccountVM.userIsSolo ? "person" : "person.3")
                    .font(.system(size: 30))
                Text(manageAccountVM.userIsSolo ? "Solo" : "Group")
            }
            
            Toggle(isOn: $manageAccountVM.userIsSolo) {
            }
            .onChange(of: manageAccountVM.userIsSolo) { newValue in
                manageAccountVM.isSaveChangesButtonIsActive = true
            }
        } .onAppear {
//            manageAccountViewModel.isPayToPlay = manageAccountViewModel.user_Is_Solo ?? false
        }
    }
    
    private var personalTitleView: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "pencil")
                    .font(.system(size: 30))
                Text("Title")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .font(.roboto(.semibold,
                                  size: 18))
            }
            TextField("",
                      text: $manageAccountVM.userTitle.max(Constants.textFieldMaxCharacters),
                      onEditingChanged: { changed in
                manageAccountVM.isSaveChangesButtonIsActive = true
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
            manageAccountVM.userTitle = manageAccountVM.user.title ?? ""
        }
    }
    
    // user's will know it as their personal ID, but on code it is their FriendID. their real ID is a uuid.
//    private var personalFriendID: some View {
//        VStack {
//            HStack(alignment: .center) {
//                Image(systemName: "barcode")
//                Text("Friend ID")
//                    .frame(maxWidth: .infinity,
//                           alignment: .leading)
//                    .font(.roboto(.semibold,
//                                  size: 15))
//            }
//            Text("\(manageAccountVM.user.friendCodeID)")
//                .frame(maxWidth: .infinity,
//                       alignment: .leading)
//                .font(.roboto(.semibold,
//                              size: 21))
//        }
//    }
    
    private var displayNameTextField: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "pencil")
                    .font(.system(size: 30))
                Text("Display Name")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .font(.roboto(.semibold,
                                  size: 18))
            }
            TextField("",
                      text: $manageAccountVM.displayName.max(Constants.textFieldMaxCharacters),
                      onEditingChanged: { changed in
                manageAccountVM.isSaveChangesButtonIsActive = true
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
            manageAccountVM.displayName = manageAccountVM.user.displayName ?? ""
        }
        .alert("Display name cannot be blank.", isPresented: $manageAccountVM.isDisplayNameTextFieldBlank, actions: {
            Button("OK", role: .cancel, action: { manageAccountVM.isDisplayNameTextFieldBlank = false })
        }, message: {
            Text("Please enter a valid display name before saving")
        })
    }
    
    private var userAgeTextView: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "birthday.cake")
                    .font(.system(size: 30))
                Text("Age")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .font(.roboto(.semibold, size: 18))
            }
            TextField("",
                      text: $manageAccountVM.userAge.max(Constants.textFieldMaxCharacters),
                      onEditingChanged: { changed in
                manageAccountVM.isSaveChangesButtonIsActive = true
                        })
            .keyboardType(.numberPad)
            .onReceive(Just(manageAccountVM.userAge)) { newUserAgeValue in
                let filtered = newUserAgeValue.filter { "0123456789".contains($0) }
                if filtered != newUserAgeValue {
                    self.manageAccountVM.userAge = filtered
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
            manageAccountVM.userAge = manageAccountVM.user.age ?? ""
        }
    }
    
    private var userLocation: some View {
        HStack(spacing: 10) {
            Image(systemName: "location")
                .font(.system(size: 30))
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Current Location")
                    .font(.roboto(.semibold, size: 18))
                Text(manageAccountVM.userLocation)
                    .font(.roboto(.regular, size: 18))
            }
            Spacer()
            Button(action: {
                manageAccountVM.locationManager.requestUserLocation { lat, long, city, state  in
                    manageAccountVM.getUserLocation(latitude: lat ?? 0.0, longitude: long ?? 0.0, city: city ?? "", state: state ?? "")
                }
            }) {
                Text("Update Location")
                    .cornerRadius(Constants.roundedCornerRadius)
                    .shadow(radius: Constants.buttonShadowRadius)
                
                    .font(.roboto(.regular, size: 14))
                    .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.roundedCornerRadius)
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
        }
        .onAppear {
            manageAccountVM.userLatitude = manageAccountVM.user.latitude ?? 0.0
            manageAccountVM.userLongitude = manageAccountVM.user.longitude ?? 0.0
            manageAccountVM.userLocation = manageAccountVM.user.location ?? ""
        }
    }
    
    private var userAvailabilityTextView: some View {
        VStack {
//            if manageAccountViewModel.userAvailability.isEmpty == true {
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .font(.system(size: 30))
                Text("Availability")
                    .foregroundColor(.gray)
                    .padding()
            }
//            }
            TextEditor(text: $manageAccountVM.userAvailability.max(Constants.textViewMaxCharacters))
                .foregroundColor(.black)
                .border(Color.black, width: 1)
                .frame(height: 200)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .onTapGesture {
                    manageAccountVM.isSaveChangesButtonIsActive = true
                }
//                .onChange(of: manageAccountViewModel.userAvailability) { newValue in
//                    manageAccountViewModel.isSaveChangesButtonIsActive = true
//                }
            
//            Text("Availability")
//                .frame(maxWidth: .infinity,
//                       alignment: .leading)
//                .font(.roboto(.semibold,
//                              size: 18))
//            TextField("",
//                      text: $manageAccountViewModel.userAvailability.max(Constants.textFieldMaxCharacters),
//                      onEditingChanged: { changed in
//                manageAccountViewModel.isSaveChangesButtonIsActive = true
//                        })
//            .padding(.horizontal, 15)
//            .frame(height: 40.0)
//            .background(Colors.textFieldGrey)
//            .background(RoundedRectangle(cornerRadius: 30))
//            .overlay(
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(Color.gray.opacity(0.80),
//                            lineWidth: 1)
//            )
        } .onAppear {
            manageAccountVM.userAvailability = manageAccountVM.user.availability ?? ""
        }
    }
    
    private var PayToPlayView: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: manageAccountVM.isPayToPlay ? "dollarsign" : "dice")
                    .font(.system(size: 30))
                Text(manageAccountVM.isPayToPlay ? "Pay to Play" : "Free to Play")
            }
            
            Toggle(isOn: $manageAccountVM.isPayToPlay) {
//                Text("Switch")
            }
            .onChange(of: manageAccountVM.isPayToPlay) { newIsPayToPlayValue in
                manageAccountVM.isSaveChangesButtonIsActive = true
            }
        } .onAppear {
            manageAccountVM.isPayToPlay = manageAccountVM.user.isPayToPlay
        }
    }
    
    private var aboutUserTextView: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .font(.system(size: 30))
                Text("Write about \(manageAccountVM.userIsSolo ? "yourself" : "your group")")
                    .foregroundColor(.gray)
                    .padding()
            }
            TextEditor(text: $manageAccountVM.about.max(Constants.textViewMaxCharacters))
                .foregroundColor(.black)
                .border(Color.black, width: 1)
                .frame(height: 200)
                .foregroundColor(manageAccountVM.about.isEmpty ? Color.black.opacity(0.25) : .black)
                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .navigationTitle("About")
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .background(Color.white)
                .onTapGesture {
                    manageAccountVM.isSaveChangesButtonIsActive = true
                }
//                .onChange(of: manageAccountViewModel.about) { newValue in
//                    manageAccountViewModel.isSaveChangesButtonIsActive = true
//                }
        }
        .onAppear {
            manageAccountVM.about = manageAccountVM.user.about ?? ""
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
                      text: $manageAccountVM.firstName.max(Constants.textFieldMaxCharacters),
                      onEditingChanged: { changed in
                manageAccountVM.isSaveChangesButtonIsActive = true
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
            manageAccountVM.firstName = manageAccountVM.user.firstName ?? ""
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
                      text: $manageAccountVM.lastName.max(Constants.textFieldMaxCharacters),
                      onEditingChanged: { changed in
                manageAccountVM.isSaveChangesButtonIsActive = true
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
            manageAccountVM.lastName = manageAccountVM.user.lastName ?? ""
        }
    }
    
    private var manageListOfGamesButtonView: some View {
        HStack(spacing: 10) {
            Image(systemName: "gamecontroller")
                .font(.system(size: 30))
            VStack {
                Button {
                    manageAccountVM.isManageListOfGamesViewShowing = true
                } label: {
                    HStack {
                        Text("Manage game preferences")
                            .font(.roboto(.semibold,
                                          size: 20))
                            .foregroundColor(.blue)
                            .padding(5)
                        Image(systemName: "chevron.right")
                            .frame(maxWidth: .infinity,
                                   alignment: .trailing)
                            .foregroundColor(.blue)
                    }
                }
                .navigationDestination(isPresented: $manageAccountVM.isManageListOfGamesViewShowing) {
                    ManageListOfGamesView()
                }
            }
            .alert("Cannot Send", isPresented: $manageAccountVM.isImageSizeExceedingLimitAlert, actions: {
                Button("OK", role: .cancel, action: {})
            }, message: {
                Text("Image size exceeds the maximum allowed size (3 MB)")
            })
        }//isImageSizeExceedingLimit
    }
    
    private var emailTextField: some View {
        VStack {
            Text("Email")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 15))
            Text("\(manageAccountVM.user.email)")
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
            Task {
                await manageAccountVM.deleteUserAccountAndFirestore()
            }
        }) {
            Text("Delete Account")
                .cornerRadius(Constants.roundedCornerRadius)
                .shadow(radius: Constants.buttonShadowRadius)
                .foregroundColor(.red)
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.roundedCornerRadius)
                        .stroke(Color.black, lineWidth: 2)
                )
            
        }
        .alert(isPresented: $manageAccountVM.accountDeleteErrorAlertIsShowing) {
            Alert(
                title: Text("Error in Deletion"),
                message: Text("You must re-sign in to re-authenticate your account before deletion"),
                primaryButton: .default(Text("Sign Out?")) {
                    Task {
                        await authenticationViewModel.signOut()
                    }
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
            manageAccountVM.updateUserInfo()
        } label: {
            Text("Save")
                .foregroundColor(manageAccountVM.isSaveChangesButtonIsActive ? Color.blue : Colors.lightGreyTwo)
//                .fontWeight(.black)
                .foregroundColor(Color(.systemIndigo))
                .multilineTextAlignment(.center)
//                .padding(.top, 15)
//                .padding(.trailing, 25)
        }
        .disabled(manageAccountVM.isSaveChangesButtonIsActive == false)
        .alert(isPresented: $manageAccountVM.accountInformationSavedAlertIsActive) {
            Alert(
                title: Text("Account Info Saved"),
                dismissButton: .default(Text("Ok")) {
                }
                
            )
        }

//            .modifier(isSaveChangesButtonIsActive ? FontModifier(size: 14, weight: .extraBold) : FontModifier(size: 14, weight: .regular))
        
    }
    
}
struct ManageAccountView_Previews: PreviewProvider {
    static var previews: some View {
        
        ManageAccountView()
    }
}
