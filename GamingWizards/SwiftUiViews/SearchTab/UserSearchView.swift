//
//  OrderView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/6/22.
//

import SwiftUI

struct UserSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userSearchVM = UserSearchViewModel()
    @StateObject private var filterer = Filterer()
    private var debouncer = Debouncer(delay: 0.5)
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    searchBar
                }
            }
            .navigationBarTitle("Looking for Group")
            .navigationDestination(isPresented: $userSearchVM.navigateToSearchResults) {
                SearchResultsView(userSearchViewModel: userSearchVM, searchText: filterer.searchText)
                
            }
        }
        .font(.globalFont(.luminari, size: 16))
        .background(
            backgroundImage
        )
        .keyboardAdaptive()
    }
    
    private var backgroundImage: some View {
        Image("realistic-billboard")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .edgesIgnoringSafeArea(.all)
    }
    
    private var searchBar: some View {
        VStack {
            SearchBar(searchText: $filterer.searchText,
                      actionButtonWasTapped: $userSearchVM.searchButtonWasTapped,
                      dropDownNotificationText: $userSearchVM.searchBarDropDownNotificationText,
                      isSearchError: $userSearchVM.isSearchError,
                      actionButtonPlaceholderText: "Search",
                      isActionButtonShowing: true, isXCancelButtonShowing: false)
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
                        .onChange(of: userSearchVM.searchButtonWasTapped, perform: { newValue in
                            if !ListOfGames.name.contains(filterer.searchText) {
                                debouncer.schedule {
                                    userSearchVM.searchBarDropDownNotificationText = "Entry did not match any of our games, please select one from the list"
                                    userSearchVM.isSearchError.toggle()
                                }
                            } else {
                                userSearchVM.navigateToSearchResults = true
                            }
                        })
                        .onTapGesture {
                            filterer.searchText = gameName
                        }
                }
            }
            .padding()
            .animation(Animation.easeInOut(duration: 0.7), value: filterer.searchText)
            .listStyle(.plain)
        }
    }

}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchView()
    }
}
