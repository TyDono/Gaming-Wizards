//
//  SearchResultsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSearchViewModel: UserSearchViewModel
    @StateObject private var searchResultsViewModel = SearchResultsViewModel()
    
    var body: some View {
        ZStack {
            Image("blank-wood")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            NavigationStack {
                List {
                    ForEach(searchResultsViewModel.users, id: \.self) { user in
                        VStack {
                            Text(user.displayName)
                        }
                        HStack {
                            ForEach(user.games, id: \.self) { game in
                                Text(game)
                            }
                        }
                    }
                }
                .background(
                    Image("blank-page")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
        .onAppear {
            searchResultsViewModel.users = searchResultsViewModel.users
            print(searchResultsViewModel.users)
        }
    }
    
    private var someNewView: some View {
        Text("ttt")
    }
    
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}
