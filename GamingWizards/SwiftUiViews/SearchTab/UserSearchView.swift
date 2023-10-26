//
//  OrderView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/6/22.
//

import SwiftUI
import CoreLocation
import Combine

struct UserSearchView: View {
    @StateObject private var userSearchVM: UserSearchViewModel
    @StateObject private var filterer = Filterer(isLayoutDesign: false)
    @StateObject var searchResultsVM: SearchResultsViewModel
    @State private var debouncer = Debouncer(delay: 0.5)
    @State private var selectedDistance: String = "150"
    @Binding var tabSelection: String
    
    init(
        debouncer: Debouncer,
        tabSelection: Binding<String>
    ) {
        self._tabSelection = tabSelection
        self._userSearchVM = StateObject(wrappedValue: UserSearchViewModel())
        self._filterer = StateObject(wrappedValue: Filterer(isLayoutDesign: false))
        self._debouncer = State(wrappedValue: debouncer)
        self._searchResultsVM = StateObject(wrappedValue: SearchResultsViewModel())
    }

    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    searchBar
                    resultView
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(Constants.lookingForGroupTitle)
                        .font(.globalFont(.luminari, size: 26))
                        .foregroundColor(.primary)
                }
            }
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationTitleView(NavigationTitleWithImage())
            .navigationBarItems(trailing:
                                    Button(action: {
                userSearchVM.isSearchSettingsViewShown.toggle()
            }) {
                Image(systemName: "slider.horizontal.3")
            })
            .navigationDestination(isPresented: $userSearchVM.isNavigateToSearchResults) {
                SearchResultsView(searchResultsVM: searchResultsVM,
                                  tabSelection: $tabSelection,
                                  searchText: $filterer.searchText)
            }
        }
        .navigationDestination(isPresented: $userSearchVM.isSearchSettingsViewShown) {
            SearchSettingsView(searchSettingsVM: userSearchVM.searchSettingsVM)
        }
        .scrollDismissesKeyboard(.automatic)
        .onTapGesture {
            hideKeyboard()
        }
//        .font(.globalFont(.luminari, size: 16))
        .font(.roboto(.regular, size: 16))
        .background(
        )
        .keyboardAdaptive()
    }
    
    private var backgroundImage: some View {
        Color(.init(white: 0.95, alpha: 1))
        /*
        Image("realistic-billboard")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
         */
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
                                    userSearchVM.isNavigateToSearchResults = true
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
//            .animation(Animation.easeInOut(duration: 0.2), value: filterer.searchText)
            
        }
    }

}

//struct UserSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            UserSearchView(
//                debouncer: Debouncer(delay: 0.5),
//                tabSelection: Binding.constant("Tab 1")
////                selectedDistance: "10"
//            )
//        }
//    }
//}

