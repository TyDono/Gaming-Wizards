//
//  SearchResultsDetailView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/18/23.
//

import SwiftUI

struct SearchResultsDetailView: View {
    @StateObject private var searchResultsDetailViewModel = SearchResultsDetailViewModel()
    @Binding var selectedUser: User
    @Binding var SpecificGame: String
    
    var body: some View {
        ZStack {
            VStack {
                Text(selectedUser.about)
                listOfGames
            }
        }
        .navigationTitle(selectedUser.displayName)
        .background(
            Image("blank-page")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private var listOfGames: some View {
        List {
            ForEach(selectedUser.games, id: \.self) { game in
                if game == SpecificGame {
                    Text(game)
                        .font(.custom(Constants.luminariRegularFontIdentifier,
                                      size: 20))
                        .bold()
                } else {
                    Text(game)
                        .font(.custom(Constants.luminariRegularFontIdentifier,
                                      size: 20))
                }
            }
        }
    }
    
}

struct SearchResultsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: "110k1") // Create an instance of User or use a mock object
        let SpecificGame = "tony hawk"
        
        return SearchResultsDetailView(selectedUser: .constant(user), SpecificGame: .constant(SpecificGame))
    }
}
