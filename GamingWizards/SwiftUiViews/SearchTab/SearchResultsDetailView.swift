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
        Button(action: {
//            searchResultsDetailViewModel.sendFriendRequest(selectedUserID: selectedUser.id)
            // instead of a friend request. this will be used to just send a message. maybe later have a private account feature in premium that will require users to send a friend request first.
        }) {
            HStack {
                Button {
                    Task {
                        do {
                            try await searchResultsDetailVM.friendRequestButtonWasTapped(newFriend: selectedUser, friendProfileImage: searchResultsDetailVM.profileImage ?? UIImage(named: Constants.wantedWizardImageString)!)
                        } catch {
                            print("ERROR friendRequestButtonWasTapped FAILED: \(error.localizedDescription)")
                            return
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                    self.tabSelection = Constants.messageTabViewString
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
            }

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

//struct SearchResultsDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = User(id: "110k1") // Create an instance of User or use a mock object
//        let SpecificGame = "tony hawk"
//        
//        return SearchResultsDetailView(selectedUser: .constant(user), specificGame: .constant(SpecificGame), tabSelection: .constant("nil"))
//    }
//}
