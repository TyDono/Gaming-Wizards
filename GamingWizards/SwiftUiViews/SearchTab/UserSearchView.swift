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
    @State private var debouncer = Debouncer(delay: 0.5)
    @Binding var tabSelection: String
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    searchBar
                    resultView
                }
            }
            .navigationBarTitle("Looking for Group")
            .navigationDestination(isPresented: $userSearchVM.navigateToSearchResults) {
                SearchResultsView(userSearchViewModel: userSearchVM, searchText: filterer.searchText, tabSelection: $tabSelection)
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
        SearchBar(searchText: $filterer.searchText,
                  actionButtonWasTapped: $userSearchVM.isSearchButtonErrorShowing,
                  dropDownNotificationText: $userSearchVM.searchBarDropDownNotificationText,
                  isSearchError: $userSearchVM.isSearchError,
                  actionButtonPlaceholderText: "Search",
                  isActionButtonEnabled: true, isActionButtonShowing: true, isXCancelButtonShowing: false)
            .animation(Animation.easeInOut(duration: 0.25), value: filterer.searchText)
    }
    
    private var resultView: some View {
        VStack {
//            searchBar
//            List {
            ScrollView {
                LazyVStack {
                    ForEach(filterer.gamesFilter, id: \.self) { game in
                        HStack {
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
                        .padding(.top, 8)
                    }
                }
            }
            .listRowBackground(Color.clear)
            .foregroundColor(Color.clear)
            .listRowBackground(Color.clear)
            .padding()
            .listStyle(.plain)
            .animation(Animation.easeInOut(duration: 0.5), value: filterer.searchText)
            
        }
    }

}

struct UserSearchView_Previews: PreviewProvider {
    @State static private var tabSelection: String = "search"

    static var previews: some View {
        NavigationView {
            UserSearchView(tabSelection: $tabSelection)
        }
    }
}
