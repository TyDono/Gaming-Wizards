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
                Text(selectedUser.displayName)
                Text(selectedUser.age)
                Text(selectedUser.groupSize)
                listOfGames
//                    .background(
//                        Image("blank-page")
//                            .resizable()
//                            .scaledToFill()
//                            .edgesIgnoringSafeArea(.all)
//                    )
                Text(selectedUser.about)
                friendRequestButton
            }
        }
        .font(.luminari(.regular, size: 16))
        .navigationTitle(selectedUser.title)
        .background(
            Image("blank-page")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private var friendRequestButton: some View {
        Button(action: {
            searchResultsDetailViewModel.sendFriendRequest(selectedUserID: selectedUser.id)
            print("Add Friend button pressed!")
        }) {
            Text("Add Friend")
                .font(.luminari(.regular, size: 16))
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
    
    private var listOfGames: some View {
        List {
            ForEach(selectedUser.games, id: \.self) { game in
                    Text(game)
                        .font(.luminari(.regular, size: 16))
                        .boldIfStringIsMatching(game, specificGame)
                        .padding(.vertical, 8)
//                        .background(
//                            Image("blank-page")
//                                .resizable()
//                                .scaledToFill()
//                        )

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

//        .listStyle(PlainListStyle())
//        .listRowBackground(
//            Image("blank-page")
//                .resizable()
//                .scaledToFill()
//                .edgesIgnoringSafeArea(.all)
//        )
//        .background(Color.red)
    }
    
}

struct SearchResultsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "110k1") // Create an instance of User or use a mock object
        let SpecificGame = "tony hawk"
        
        return SearchResultsDetailView(selectedUser: .constant(user), specificGame: .constant(SpecificGame))
    }
}
