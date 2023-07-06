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
    @State var users: [User] = []
    
    var body: some View {
        ZStack {
            NavigationStack {
                HStack {
                    searchBar
                }
            }
            .navigationBarTitle("Looking for Group")
            .navigationDestination(isPresented: $searchButtonWasTapped) {
                SearchResultsView(userSearchViewModel: userSearchViewModel, searchText: userSearchViewModel.searchText)
                
           }
        }
        .font(.globalFont(.luminari, size: 16))
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
            SearchBar(searchText: $userSearchViewModel.searchText, isNavigatingToSearchResults: $searchButtonWasTapped, placeholder: "Search", isSearchButtonShowing: true, isXCancelButtonShowing: false)
                .animation(Animation.easeInOut(duration: 0.25), value: userSearchViewModel.searchText)
            List {
                ForEach(userSearchViewModel.filteredGames, id: \.self) { gameName in
                    Text(gameName)
                        .foregroundColor(.black)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 5)
                                .background(.clear)
                                .foregroundColor(userSearchViewModel.searchText.isEmpty ? .clear : .white)
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
                            userSearchViewModel.searchText = gameName
                        }
                        .onChange(of: searchButtonWasTapped) { newValue in
                            if newValue {
                            }
                        }
                }
            }
            .padding()
            .animation(Animation.easeInOut(duration: 0.7), value: userSearchViewModel.searchText)
            .listStyle(.plain)
        }
    }

}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchView()
    }
}
