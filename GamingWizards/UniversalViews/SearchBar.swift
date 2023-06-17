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
    @State var isDropDownNotificationShowing: Bool = false
    var isXCancelButtonShowing: Bool = false
    
    var body: some View {
        textFieldView
    }
    
    private var textFieldView: some View {
        VStack {
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
                .modifier(ShakeEffect(shakes: searchBarIsShaking ? 2 : 0))
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
            if isDropDownNotificationShowing == true {
                    dropDownNotificationView
                        .padding(.vertical, 8)
                        .padding(.leading, 8)
                        .padding(.trailing, 4)
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
                    isDropDownNotificationShowing = false
                }
                .padding(.trailing, 8)
    }
    
    private var dropDownNotificationView: some View {
        Text("you must select an option below to search for")
                           .font(.subheadline)
                           .padding(.horizontal, 8)
                           .padding(.vertical, 4)
                           .background(Color.white)
                           .clipShape(RoundedRectangle(cornerRadius: 8))
                           .offset(x: 0, y: -28)
                           .animation(.easeInOut(duration: 0.35), value: isDropDownNotificationShowing)
                           .onTapGesture {
                               withAnimation(Animation.easeInOut(duration: 0.35)) {
                                   isDropDownNotificationShowing = false
                               }
                           }
//            .background(
//                RoundedRectangle(cornerRadius: 8)
//                    .background(.clear)
//                    .foregroundColor(.white)
//            )
    }
    
    private var searchButtonView: some View {
        Text(placeholder)
            .font(.luminari(.regular, size: 16))
            .padding(8)
            .animation(Animation.easeInOut(duration: 0.5), value: isSearchButtonShowing)
            .background(.blue)
            .cornerRadius(Constants.roundedCornerRadius)
            .foregroundColor(.white)
            .onTapGesture {
                if ListOfGames.name.contains(searchText) {
                    withAnimation(Animation.easeInOut(duration: 0.25)) {
                        isDropDownNotificationShowing = false
                    }
                    isNavigatingToSearchResults = true
                    
                } else {
                    withAnimation(Animation.easeInOut(duration: 0.6).speed(1)) {
                        searchBarIsShaking.toggle()
                        isDropDownNotificationShowing = true
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
