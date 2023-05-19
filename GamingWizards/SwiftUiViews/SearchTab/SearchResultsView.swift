//
//  SearchResultsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSearchViewModel: UserSearchViewModel
    @StateObject var searchResultsViewModel = SearchResultsViewModel()
    @State var resultWasTapped: Bool = false
    @State var selectedUser: User = User(id: "110k1")
    @State var searchText: String
    
    var body: some View {
        ZStack {
            NavigationView {
                searchResultsList
//                    .background(
//                        backgroundImage
//                    )
            }
        }
        .navigationDestination(isPresented: $resultWasTapped) {
            SearchResultsDetailView(selectedUser: $selectedUser, SpecificGame: $searchText)
       }
        .background(
            backgroundImage
        )
//        .background(
//            backgroundImage
//        )
        .onAppear {
            searchResultsViewModel.callPerformSearchForMatchingGames(gameName: searchText)
        }
    }
    
    private var searchResultsList: some View {
        List {
            ForEach(searchResultsViewModel.users ?? [], id: \.self) { user in
                VStack {
                    Text(user.displayName)
                    HStack {
                        ForEach(user.games, id: \.self) { game in
                            Text(game)
                        }
                    }
                }
                .onTapGesture {
                    self.selectedUser = user
                    resultWasTapped = true
                }
            }
            .background (
                Image("blank-page")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .background(
            backgroundImage
        )
    }
    
    private var backgroundImage: some View {
        Image("blank-wood")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let userSearchViewModel = UserSearchViewModel()
        let searchText = "Example Search"
        let selectedUser = User(id: "110k1")
        
        return SearchResultsView(userSearchViewModel: userSearchViewModel, selectedUser: selectedUser, searchText: searchText)
    }
}
