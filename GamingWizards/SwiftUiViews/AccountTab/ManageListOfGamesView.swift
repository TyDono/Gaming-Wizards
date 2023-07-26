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
    @State private var textColor: Color = Color.black
    @State private var backgroundColor: Color = Color.lightGrey
    @State var gameItems: [FlowTag] = []
    
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
                      actionButtonPlaceholderText: "Search",
                      isActionButtonEnabled: false,
                      isActionButtonShowing: manageListOfGamesVM.isSearchButtonShowing)
            .animation(Animation.easeInOut(duration: 0.25), value: filterer.searchText)
            ScrollView {
                FlowLayout(mode: .scrollable,
                           binding: $filterer.searchText,
                           items: filterer.gamesFilter) { gameItem in
                    Text(gameItem.textName)
                        .font(.globalFont(.luminari, size: 12))
//                        .foregroundColor(gameItem.textColor)
                        .foregroundColor(gameItem.isSelected ? Color.white : Color.black)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.tagFlowLayoutCornerRadius)
                                .border(Color.clear)
//                                .foregroundColor(gameItem.backgroundColor)
                                .foregroundColor(gameItem.isSelected ? Color.blue : Color.lightGrey)
                                .padding(-8)
                        )
                        .padding()
                        .onTapGesture {
//                            updateGameTagColorsOnTapGesture()
                            manageListOfGamesVM.gameTagWasTapped(tappedGameTag: gameItem)
                            filterer.searchText = filterer.searchText // Updates the UI. dons't know why. don't try. accept monkey wrench code here.
//                            updateGameTagColorsOnTap(for: gameItem)
                        }
                }
            }
            .onAppear {
                manageListOfGamesVM.updateGameTagsWithMatchingGames(filterer: filterer.gamesFilter)
//                updateGameTagsWithMatchingGames()
//                updateColorsForTags()
            }
        }
        .animation(Animation.easeInOut(duration: 0.7), value: filterer.searchText)
    }
    
    private func updateGameTagColorsOnTapGesture() { // not used
        for index in filterer.gamesFilter.indices {
            if filterer.gamesFilter[index].isSelected {
                filterer.gamesFilter[index].textColor = Color.white
                filterer.gamesFilter[index].backgroundColor = Color.blue
            } else {
                filterer.gamesFilter[index].textColor = Color.black
                filterer.gamesFilter[index].backgroundColor = Color.lightGrey
            }
        }
//        filterer.searchText = tappedGameTag.textName
    }
    
    private func updateGameTagColorsOnTap(for tappedGameTag: FlowTag) { // not used
        // Create a dictionary to store the selected tag's index and its current colors
        var selectedTagColors: [Int: (textColor: Color, backgroundColor: Color)] = [:]

        // Loop through the filterer.gamesFilter to populate the dictionary and update the selected tag's colors
        for index in filterer.gamesFilter.indices {
            let tag = filterer.gamesFilter[index]
            if tag == tappedGameTag {
                if tag.backgroundColor == Color.blue {
                    selectedTagColors[index] = (textColor: Color.black, backgroundColor: Color.lightGrey)
                } else {
                    selectedTagColors[index] = (textColor: Color.white, backgroundColor: Color.blue)
                }
            } else {
                // Store the original colors for other tags
                selectedTagColors[index] = (textColor: Color.black, backgroundColor: Color.lightGrey)
            }
        }

        // Assign the updated colors from the dictionary back to the tags
        for (index, colors) in selectedTagColors {
            filterer.gamesFilter[index].textColor = colors.textColor
            filterer.gamesFilter[index].backgroundColor = colors.backgroundColor
        }
        
        // Reset the searchText to trigger the view update
        filterer.searchText = tappedGameTag.textName
    }
    
    private func updateColorsForTags() { // not used
        for index in filterer.gamesFilter.indices {
            let gameName = filterer.gamesFilter[index].textName
            if manageListOfGamesVM.user.listOfGames?.contains(gameName) == true {
                filterer.gamesFilter[index].textColor = Color.white
                filterer.gamesFilter[index].backgroundColor = Color.blue
            } else {
                filterer.gamesFilter[index].textColor = Color.black
                filterer.gamesFilter[index].backgroundColor = Color.lightGrey
            }
        }
    }
    
}

struct ManageListOfGamesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageListOfGamesView()
    }
}
