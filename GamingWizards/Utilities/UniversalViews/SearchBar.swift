//
//  SearchBar.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/3/23.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var isNavigatingToSearchResults: Bool
    @State var gameListDidNotMatch: Bool = false
    @State var searchBarIsShaking: Bool = false
    @State private var shakeCount = 0
    @State var placeholder: String
    @State var isSearchButtonShowing: Bool
    var isXCancelButtonShowing: Bool = false
    
    var body: some View {
        textFieldView
//            .shakeEffect(isShaking: searchBarIsShaking)
    }
    
    private var textFieldView: some View {
        HStack {
            TextField(placeholder, text: $searchText, onEditingChanged: { isEditing in
                isSearchButtonShowing = true
            })
            .font(.luminari(.regular, size: 16))
            .padding(8)
            .padding(.horizontal, 20)
            .background(Color(.systemGray6))
            .cornerRadius(Constants.roundedCornerRadius)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    if searchText != "" {
                        xCancelButtonView
                    }
                }
            )
            .shakingAnimation(isShaking: searchBarIsShaking, shakeCount: 4)
            .padding(.vertical, 8)
            .padding(.leading, 8)
            .padding(.trailing, 4)
            .padding(.trailing, isSearchButtonShowing ? 0 : 8)
            if searchText != "" {
                searchButtonView
                    .padding(.trailing, 8)
                    .padding(.vertical, 8)
            }
            
        }
    }
    
    private var xCancelButtonView: some View {
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .onTapGesture {
                    self.searchText = ""
                }
                .padding(.trailing, 8)
    }
    
    private var searchButtonView: some View {
        Text(placeholder)
            .font(.luminari(.regular, size: 16))
            .padding(8)
            .animation(Animation.easeInOut(duration: 0.2), value: isSearchButtonShowing)
            .background(.blue)
            .cornerRadius(Constants.roundedCornerRadius)
            .foregroundColor(.white)
            .onTapGesture {
                if ListOfGames.name.contains(searchText) {
                    isNavigatingToSearchResults = true
                } else {
                    withAnimation(Animation.easeInOut(duration: 0.5).repeatCount(4)) {
                        searchBarIsShaking.toggle()
                    }
                }
                
            }
        
//        NavigationLink {
////            performSearchForMatchingGames(game: <#T##String#>) { games, err in
////                if error = err {
////                    print("SEARCH FOR MATCHING GAMES ERROR: \(error.localizedDescription)")
////                }
////            }
//            SearchResultsView()
////                    .environmentObject(friendListVM)
//        } label: {
//            Text("Search")
//                .font(.luminari(.regular, size: 16))
//                .padding(8)
//                .animation(Animation.easeInOut(duration: 0.2), value: isSearchButtonShowing)
//                .background(.blue)
//                .cornerRadius(10)
//                .foregroundColor(.white)
//
//        }
    }
    
}
