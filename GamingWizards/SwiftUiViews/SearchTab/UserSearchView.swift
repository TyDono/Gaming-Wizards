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
                SearchResultsView(userSearchViewModel: userSearchVM, searchText: filterer.searchText)
                
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
            SearchBar(searchText: $filterer.searchText, actionButtonWasTapped: $searchButtonWasTapped, dropDownNotificationText: $userSearchVM.searchBarDropDownNotificationText, actionButtonPlaceholderText: "Search", isActionButtonShowing: true, isXCancelButtonShowing: false)
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
