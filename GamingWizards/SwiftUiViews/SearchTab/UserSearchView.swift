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
                      actionButtonWasTapped: $userSearchVM.isSearchButtonErrorShowing,
                      dropDownNotificationText: $userSearchVM.searchBarDropDownNotificationText,
                      isSearchError: $userSearchVM.isSearchError,
                      actionButtonPlaceholderText: "Search",
                      isActionButtonEnabled: true, isActionButtonShowing: true, isXCancelButtonShowing: false)
                .animation(Animation.easeInOut(duration: 0.25), value: filterer.searchText)
            List {
                ForEach(filterer.gamesFilter, id: \.self) { game in
                    
                    Button {
                        filterer.searchText = game.textName
                    } label: {
                        SearchResultCellView(index: 0, text: game.textName, isEmptyCell: filterer.searchText.isEmpty)
                    }
                    .listRowBackground(Color.clear)
                    .onChange(of: userSearchVM.isSearchButtonErrorShowing, perform: { newValue in
                        if !ListOfGames.name.contains(filterer.searchText) {
                            debouncer.schedule {
                                userSearchVM.searchBarDropDownNotificationText = "Entry did not match any of our games, please select one from the list"
                                userSearchVM.isSearchError.toggle()
                            }
                        } else {
                            userSearchVM.navigateToSearchResults = true
                        }
                    })
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
