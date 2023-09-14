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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var userSearchVM: UserSearchViewModel
    @StateObject private var filterer = Filterer(isLayoutDesign: false)
    @State private var debouncer = Debouncer(delay: 0.5)
    @State private var selectedDistance: String = "150"
    @Binding var tabSelection: String
    private let distanceOptions: [String] = [
        "10", "50", "100",
        "150", "200", "250", "No Limit"
    ]
    
    init(debouncer: Debouncer, tabSelection: Binding<String>) {
        self._tabSelection = tabSelection
        self._userSearchVM = ObservedObject(wrappedValue: UserSearchViewModel())
        self._filterer = StateObject(wrappedValue: Filterer(isLayoutDesign: false))
        self._debouncer = State(wrappedValue: debouncer)
//        self._selectedDistance = selectedDistance
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    distancePicker
                    searchBar
                    resultView
                }
            }
            .navigationBarTitle("Looking for Group")
            .navigationDestination(isPresented: $userSearchVM.navigateToSearchResults) {
                SearchResultsView(tabSelection: $tabSelection, searchText: filterer.searchText)
            }
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
    
    private var distancePicker: some View {
           VStack {
               Text("Miles")
                   .padding(.horizontal, 16)
                   .padding(.vertical, 8)
                   .background(Color.white)
                   .cornerRadius(8)
               Picker("Distance", selection: $selectedDistance) {
                   ForEach(distanceOptions, id: \.self) { option in
                       Text(option)
                   }
               }
               .pickerStyle(SegmentedPickerStyle())
               .customPickerBackground(selected: true)
           }
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
    static var previews: some View {
        NavigationView {
            UserSearchView(
                debouncer: Debouncer(delay: 0.5),
                tabSelection: Binding.constant("Tab 1")
//                selectedDistance: "10"
            )
        }
    }
}

