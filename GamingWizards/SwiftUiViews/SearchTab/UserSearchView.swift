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
    @State private var isSearchButtonShowing: Bool = false
    @State var searchButtonWasTapped: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                HStack {
                    searchBar
                }
            }
            .navigationBarTitle("Looking for Group")
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
            SearchBar(searchText: $userSearchViewModel.searchText, searchButtonWasTapped: $searchButtonWasTapped, placeholder: "Search", isSearchButtonShowing: true, isXCancelButtonShowing: false)
                .animation(Animation.easeInOut(duration: 0.2), value: userSearchViewModel.searchText)
                .font(.luminari(.regular, size: 16))
            List {
                ForEach(userSearchViewModel.filteredGames, id: \.self) { name in
                    //            List(userSearchViewModel.filteredGames, id: \.self) { name in
                    Text(name)
                        .font(.luminari(.regular, size: 16))
                        .onTapGesture {
                            userSearchViewModel.searchText = name
                        }
                        .onChange(of: searchButtonWasTapped) { newValue in
                            if newValue {
                                print("value was changed!")
                //                anotherFunction()
                            }
                        }
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
