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
    @ObservedObject var user = UserObservable.shared
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
    @StateObject private var manageAccountVM = ManageAccountViewModel()
    @StateObject private var filterer = Filterer()
    @State var nilNavigation = false

    
//    let session: SessionStore
    
//    init(viewModel: ManageAccountViewModel) {
//        self.manageAccountViewModel = viewModel
//    }
    
    var body: some View {
            ZStack(alignment: .bottom) {

                VStack {
                    ScrollView {
                        
                        Group {
                            listOfGamesView
                                .padding()
                        }
                        
                        Group {
                            Spacer().frame(height: 16)
                            profileImageView
                                .padding()
                            personalTitleView
                                .padding()
                            displayNameTextField
                                .padding()
//                            firstNameTextField
//                                .padding()
//                            lastNameTextField
//                                .padding()
                            userAgeTextView
                                .padding()
                            userLocationTextView
                                .padding()
                        }
                        Group {
                            aboutUserTextView
                                .padding()
                            userAvailabilityTextView
                                .padding()
                            userIsSoloView
                                .padding()
                            PayToPlayView
                                .padding()
//                            listOfGamesView
//                                .padding()
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
            Image(uiImage: (manageAccountVM.profileImage ?? UIImage(named: "WantedWizard+"))!)
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
                    .cornerRadius(5)
            }
        }
        .onAppear(perform: manageAccountVM.loadProfileImageFromDisk)
        .sheet(isPresented: $manageAccountVM.isShowingImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $manageAccountVM.profileImage)
        }
    }
    
    private var userIsSoloView: some View {
        VStack {
            Text(manageAccountVM.userIsSolo ? "Solo" : "Group")
            
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
            Text("Title")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
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
    private var personalFriendID: some View {
        VStack {
            Text("Friend ID")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 15))
            Text("\(manageAccountVM.user.friendCodeID)")
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
    }
    
    private var userAgeTextView: some View {
        VStack {
            Text("Age")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
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
    
    private var userLocationTextView: some View {
        VStack {
            Text("Location")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 18))
            TextField("",
                      text: $manageAccountVM.userLocation.max(Constants.textFieldMaxCharacters),
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
            manageAccountVM.userLocation = manageAccountVM.user.location ?? ""
        }
    }
    
    private var userAvailabilityTextView: some View {
        VStack {
//            if manageAccountViewModel.userAvailability.isEmpty == true {
                Text("Availability")
                    .foregroundColor(.gray)
                    .padding()
//            }
            TextEditor(text: $manageAccountVM.userAvailability.max(Constants.textViewMaxCharacters))
                .foregroundColor(.black)
                .border(Color.black, width: 1)
                .frame(height: 200)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .navigationTitle("Availability")
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
            Text(manageAccountVM.isPayToPlay ? "Pay to Play" : "Free to Play")
            
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
//            if manageAccountViewModel.about.isEmpty == true {
                Text("Write about \(manageAccountVM.userIsSolo ? "yourself" : "your group")")
                    .foregroundColor(.gray)
                    .padding()
//            }
            TextEditor(text: $manageAccountVM.about.max(Constants.textViewMaxCharacters))
                .foregroundColor(.black)
                .border(Color.black, width: 1)
                .frame(height: 200)
                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .navigationTitle("About")
                .foregroundStyle(.secondary)
                .padding(.horizontal)
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
    
    private var listOfGamesView: some View {
        VStack {
            Text("Games")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 15))
            SearchBar(searchText: $filterer.searchText, actionButtonWasTapped: $manageAccountVM.addGameButtonWasTapped, dropDownNotificationText: $manageAccountVM.searchBarDropDownNotificationText, actionButtonPlaceholderText: "Add", isActionButtonShowing: manageAccountVM.isSearchButtonShowing)
                .animation(Animation.easeInOut(duration: 0.25), value: filterer.searchText)
            List {
                ForEach(filterer.gamesFilter, id: \.self) { gameName in
                    Text(gameName)
                        .foregroundColor(.black)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 5)
                                .background(.clear)
                                .foregroundColor(filterer.searchText.isEmpty ? .clear : .white)
                                .padding(
                                    EdgeInsets(
                                        top: 2,
                                        leading: 6,
                                        bottom: 2,
                                        trailing: 6
                                    )
                                )
                        )
                        .onTapGesture {
                            filterer.searchText = gameName
                        }
                        .onChange(of: manageAccountVM.addGameButtonWasTapped) { newValue in
                            if ((manageAccountVM.user.listOfGames?.contains(filterer.searchText)) != nil) {
                                // perform error "you already have this added"
                                print("already added")
                            } else {
                                manageAccountVM.listOfGames.append(filterer.searchText)
                                print("added in")
                            }
                        }
                }
            }
            .padding()
            .animation(Animation.easeInOut(duration: 0.7), value: filterer.searchText)
            .listStyle(.plain)
        }
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
            manageAccountVM.deleteUserAccount()
        }) {
            Text("Delete Account")
                .foregroundColor(.red)
            
        }
        .alert(isPresented: $manageAccountVM.accountDeleteErrorAlertIsShowing) {
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
            manageAccountVM.updateUserInfo()
        } label: {
            Text("Save")
                .foregroundColor(manageAccountVM.isSaveChangesButtonIsActive ? Colors.black70 : Colors.lightGreyTwo)
                .fontWeight(.black)
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
