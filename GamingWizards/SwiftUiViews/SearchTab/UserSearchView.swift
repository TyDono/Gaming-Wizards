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
                searchBar
            }
            .navigationTitle("Looking for Group")
        }
        .background(
            backgroundImage
        )
    }
    
    private var backgroundImage: some View {
            Image("realistic-billboard")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
    }
    
    private var searchBar: some View {
        VStack {
            SearchBar(text: $userSearchViewModel.searchText, placeholder: "Search")
            List(userSearchViewModel.filteredGames, id: \.self) { name in
                Text(name)
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
