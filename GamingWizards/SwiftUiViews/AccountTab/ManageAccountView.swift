//
//  SettingsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/27/22.
//

import SwiftUI
import Combine

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
                    Spacer()
                    List {
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
            .onChange(of: manageAccountViewModel.firstName) { newValue in
                manageAccountViewModel.isSaveChangesButtonIsActive = true
            }
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
        }
        .padding()
        .onChange(of: manageAccountViewModel.about, perform: { newValue in
            manageAccountViewModel.isSaveChangesButtonIsActive = true
        })
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
            .onChange(of: manageAccountViewModel.firstName) { newValue in
//                                manageAccountViewModel.isSaveChangesButtonIsActive = true
            }
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
            .onChange(of: manageAccountViewModel.lastName) { newValue in
                manageAccountViewModel.isSaveChangesButtonIsActive = true
            }
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
    
    private var customNavigationBar: some View {
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
