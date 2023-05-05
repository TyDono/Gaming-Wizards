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
    @State var placeholder: String
    @State var isSearchButtonShowing: Bool
     var isXCancelButtonShowing: Bool = false
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $searchText, onEditingChanged: { isEditing in
                isSearchButtonShowing = true
            })
                .font(.custom("Luminari", size: 16))
                .padding(8)
                .padding(.horizontal, 20)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if searchText != "" {
                            xCancelButton
                        }
                    }
                )
                .padding(.vertical, 8)
                .padding(.leading, 8)
                .padding(.trailing, 4)
                .padding(.trailing, isSearchButtonShowing ? 0 : 8)
            if searchText != "" {
                searchButton
                    .padding(.trailing, 8)
                    .padding(.vertical, 8)
            }
            
        }
    }
    
    private var xCancelButton: some View {
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .onTapGesture {
                    self.searchText = ""
                }
                .padding(.trailing, 8)
    }
    
    private var searchButton: some View { //not using. might delete later :3
        NavigationLink {
            SearchResultsView()
//                    .environmentObject(friendListVM)
                .onAppear {
                    print("i apeared")
//                        friendListVM.friendWasTapped(friend: friend)
                }
        } label: {
            Text("Search")
                .font(.custom("Luminari", size: 16))
                .padding(8)
                .animation(Animation.easeInOut(duration: 0.2), value: isSearchButtonShowing)
                .background(.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
                    
        }
    }
    
}
