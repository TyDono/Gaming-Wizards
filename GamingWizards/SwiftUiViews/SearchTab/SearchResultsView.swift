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
    @StateObject var searchResultsViewModel = SearchResultsViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                searchResultsList
            }
        }
//        .background(
//            backgroundImage
//        )
        .onAppear {
//            searchResultsViewModel.users = userSearchViewModel.users
//            print(searchResultsViewModel.users)
        }
    }
    
    private var searchResultsList: some View {
        List {
            ForEach(searchResultsViewModel.users, id: \.self) { user in
                VStack {
                    Text(user.displayName)
                }
                HStack {
                    ForEach(user.games, id: \.self) { game in
                        Text(game)
                            .background (
                                Image("blank-page")
                                    .resizable()
//                                            .scaledToFill()
//                                            .edgesIgnoringSafeArea(.all)
                            )
                    }
                }
            }
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
        SearchResultsView()
            .environmentObject(UserSearchViewModel())
    }
}
