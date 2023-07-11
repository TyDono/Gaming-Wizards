//
//  SearchResultsDetailView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/18/23.
//

import SwiftUI

struct SearchResultsDetailView: View {
    @StateObject private var searchResultsDetailViewModel = SearchResultsDetailViewModel()
    @Binding var selectedUser: User
    @Binding var specificGame: String
    
    var body: some View {
        ZStack {
            VStack {
                viewAccountView
                    .padding()
                friendRequestButton
                    .font(.globalFont(.luminari, size: 16))
                    .padding()
            }
        }
        .background(
            backgroundImageView
        )
        .task {
            searchResultsDetailViewModel.callRetrieveUserProfileImage(selectedUserProfileImageString: selectedUser.profileImageString)
        }
        
    }
    
    private var backgroundImageView: some View {
        Image("blank-page")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
    }
    
    private var viewAccountView: some View {
        AccountView(displayName: $selectedUser.displayName, userLocation: $selectedUser.location, profileImageString: $selectedUser.profileImageString, profileImage: $searchResultsDetailViewModel.profileImage, friendCodeId: $selectedUser.friendCodeID, listOfGames: $selectedUser.listOfGames, groupSize: $selectedUser.groupSize, age: $selectedUser.age, about: $selectedUser.about, title: $selectedUser.title, availability: $selectedUser.availability, isPayToPlay: $selectedUser.isPayToPlay, isUserSolo: $selectedUser.isSolo)
    }
    
    private var friendRequestButton: some View {
        Button(action: {
            searchResultsDetailViewModel.sendFriendRequest(selectedUserID: selectedUser.id)
            print("Add Friend button pressed!")
        }) {
            Text("Add Friend")
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
        let user = User(id: "110k1") // Create an instance of User or use a mock object
        let SpecificGame = "tony hawk"
        
        return SearchResultsDetailView(selectedUser: .constant(user), specificGame: .constant(SpecificGame))
    }
}
