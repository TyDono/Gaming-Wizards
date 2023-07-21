//
//  ManageListOfGamesView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/18/23.
//

import Foundation
import SwiftUI

struct ManageListOfGamesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var filterer = Filterer()
    @StateObject private var manageListOfGamesVM = ManageListOfGamesViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    listOfGamesView
                }
            }
            .navigationBarTitle("Personal List of Games")
        }
        .font(.roboto(.semibold, size: 16))
        .keyboardAdaptive()
    }
    
    private var listOfGamesView: some View {
        VStack {
            SearchBar(searchText: $filterer.searchText,
                      actionButtonWasTapped: $manageListOfGamesVM.addGameButtonWasTapped,
                      dropDownNotificationText: $manageListOfGamesVM.searchBarDropDownNotificationText,
                      isSearchError: $manageListOfGamesVM.isSearchError,
                      actionButtonPlaceholderText: "Add",
                      isActionButtonShowing: manageListOfGamesVM.isSearchButtonShowing)
            .animation(Animation.easeInOut(duration: 0.25), value: filterer.searchText)
            ScrollView {
                FlowLayout(mode: .scrollable,
                           binding: .constant(5),
                           items: filterer.gamesFilter) { gameName in
//                    if manageListOfGamesVM.user.listOfGames?.contains(gameName) {
                        //                    }
                        Text(gameName)
                            .font(.globalFont(.luminari, size: 12))
                            .foregroundColor(.black)
//                            .background(
//                                RoundedRectangle(cornerRadius: Constants.tagFlowLayoutCornerRadius)
//                                    .border(Color.clear)
//                                    .foregroundColor(Color.lightGrey)
//                                    .padding(-8)
//                            )
                            .padding()
                            .onTapGesture {
                                filterer.searchText = gameName
                            }
                }
            }
            .animation(Animation.easeInOut(duration: 0.7), value: filterer.searchText)
        }
    }
    
}

struct ManageListOfGamesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageListOfGamesView()
    }
}
