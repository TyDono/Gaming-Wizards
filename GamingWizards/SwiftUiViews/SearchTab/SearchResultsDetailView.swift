//
//  SearchResultsDetailView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/18/23.
//

import SwiftUI

struct SearchResultsDetailView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var searchResultsDetailVM: SearchResultsDetailViewModel
    //    @Environment(\.dismiss) var dismiss
    @Binding var selectedUser: User
    @Binding var specificGame: String
    @Binding var tabSelection: String
    
    init(
        searchResultsDetailVM: SearchResultsDetailViewModel = SearchResultsDetailViewModel(),
        selectedUser: Binding<User>,
        specificGame: Binding<String>,
        tabSelection: Binding<String>
    ) {
        self._searchResultsDetailVM = StateObject(wrappedValue: SearchResultsDetailViewModel())
        self._selectedUser = selectedUser
        self._specificGame = specificGame
        self._tabSelection = tabSelection
    }
    
    var body: some View {
        ZStack {
            VStack {
                viewAccountView
                    .padding()
                friendRequestButton
                //                reportUserButton
                //                    .font(.globalFont(.luminari, size: 16))
                    .padding()
            }
        }
        .background(
            //            backgroundImageView
        )
        .task {
            searchResultsDetailVM.callRetrieveUserProfileImage(selectedUserProfileImageString: selectedUser.profileImageString)
        }
        
    }
    
    private var backgroundImageView: some View {
        Color(.init(white: 0.95, alpha: 1))
        /*
         Image("blank-page")
         .resizable()
         .aspectRatio(contentMode: .fill)
         .edgesIgnoringSafeArea(.all)
         */
    }
    
    private var viewAccountView: some View {
        AccountView(displayName: $selectedUser.displayName, userLocation: $selectedUser.location, profileImageString: $selectedUser.profileImageString, profileImage: $searchResultsDetailVM.profileImage, listOfGames: $selectedUser.listOfGames, groupSize: $selectedUser.groupSize, age: $selectedUser.age, about: $selectedUser.about, title: $selectedUser.title, availability: $selectedUser.availability, isPayToPlay: $selectedUser.isPayToPlay, isUserSolo: $selectedUser.isSolo)
    }
    
    private var friendRequestButton: some View {
        //            searchResultsDetailViewModel.sendFriendRequest(selectedUserID: selectedUser.id)
        // instead of a friend request. this will be used to just send a message. maybe later have a private account feature in premium that will require users to send a friend request first.
        HStack {
            Button {
                searchResultsDetailVM.isShowingSendMessageConfirmationAlert.toggle()
            } label: {
                Text("Send Message")
                //                        .font(.globalFont(.luminari, size: 21))
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
            .alert("Add Friend", isPresented: $searchResultsDetailVM.isShowingSendMessageConfirmationAlert, actions: {
                Button("Yes", action: {
                    Task {
                        do {
                            try await searchResultsDetailVM.friendRequestButtonWasTapped(newFriend: selectedUser, friendProfileImage: searchResultsDetailVM.profileImage ?? UIImage(named: Constants.wantedWizardImageString)!)
                        } catch {
                            print("ERROR friendRequestButtonWasTapped FAILED: \(error.localizedDescription)")
                            return
                        }
                    }
                    searchResultsDetailVM.isShowingSendMessageConfirmationAlert.toggle()
                    presentationMode.wrappedValue.dismiss()
                    self.tabSelection = Constants.messageTabViewString
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Are you sure you want to contact \(selectedUser.displayName ?? "this user")?")
            })
        }
        .alert("Cannot Send", isPresented: $searchResultsDetailVM.isFailedToSendMessageShowing, actions: {
            Button("OK", role: .cancel, action: {})
        }, message: {
            Text("Failed to send message to user, please check your internet connection.")
        })
        
    }
    
    private var listOfGames: some View {
        List {
            ForEach(selectedUser.listOfGames ?? [], id: \.self) { game in
                Text(game)
                    .boldIfStringIsMatching(game, specificGame)
                    .padding(.vertical, 8)
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    .foregroundColor(.white)
                    .padding(
                        EdgeInsets(
                            top: 2,
                            leading: 6,
                            bottom: 2,
                            trailing: 6
                        )
                    )
            )
        }
        .listStyle(.plain)
        .background(Color.clear)
    }
    
}

struct SearchResultsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "110k1", displayName: "John Doe", location: "City", profileImageString: "profile_image_placeholder", listOfGames: ["Game A", "Game B"], groupSize: "3-4", age: "25", about: "About me...", availability: "Evenings", title: "Gamer", isPayToPlay: false, isSolo: false)
        let specificGame = "Game A"
        
        return SearchResultsDetailView(selectedUser: .constant(user), specificGame: .constant(specificGame), tabSelection: .constant("nil"))
    }
}

