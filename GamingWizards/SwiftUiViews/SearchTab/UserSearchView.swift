//
//  OrderView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/6/22.
//

import SwiftUI

struct UserSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userSearchViewModel = UserSearchViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                HStack {
                    searchBar
//                    searchButton
                }
            }
            .navigationTitle("Looking for Group")
//            .navigationBarTitleDisplayMode(.inline)
//            .font(.custom("Luminari", size: 16))
        }
        .background(
            backgroundImage
        )
    }
    
    private var searchButton: some View {
        NavigationLink {
            SearchResultsView()
//                    .environmentObject(friendListVM)
                .onAppear {
                    print("i apeared")
//                        friendListVM.friendWasTapped(friend: friend)
                }
        } label: {
            Text("Search")
                .background(.blue)
                    .cornerRadius(15)
        }
    }
    
    private var backgroundImage: some View {
            Image("realistic-billboard")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
    }
    
    private var searchBar: some View {
        VStack {
            SearchBar(searchText: $userSearchViewModel.searchText, placeholder: "Search", isSearchButtonShowing: false, isXCancelButtonShowing: false)
                .animation(Animation.easeInOut(duration: 0.2), value: userSearchViewModel.searchText)
//                .font(.custom("Luminari", size: 16))
            List(userSearchViewModel.filteredGames, id: \.self) { name in
                Text(name)
//                    .font(.custom("Luminari", size: 16))
                    .onTapGesture {
                        userSearchViewModel.searchText = name
                    }
            }
            .padding()
            .animation(Animation.easeInOut(duration: 0.7), value: userSearchViewModel.searchText)
//            .animation(Animation.easeInOut(duration: 1.0), value: offset)
            .listStyle(.plain)
//            .cornerRadius(25)
//            .listStyle(.insetGrouped)
        }
    }

}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchView()
    }
}
