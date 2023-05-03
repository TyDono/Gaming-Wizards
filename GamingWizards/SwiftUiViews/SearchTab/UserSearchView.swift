//
//  OrderView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/6/22.
//

import SwiftUI

struct UserSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userSearchViewModel = UserSearchViewModel()
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
//            backgroundImage
            //            Image("realistic-billboard")
            //                .resizable()
            //                .scaledToFill()
            //                .edgesIgnoringSafeArea(.all)
//            NavigationStack {
            VStack {
//                backgroundImage
                List {
                    ForEach(userSearchViewModel.filteredGames, id: \.self) { name in
                        Text(name)
                    }
                }
            }
//            }
            .navigationTitle("Looking for Group")
            .searchable(text: $userSearchViewModel.searchText) {
//                ForEach(userSearchViewModel.filteredGames, id: \.self) { name in
//                    Text(name)
//                        .searchCompletion(name)
//                }
            }
//            .searchable(text: $userSearchViewModel.searchText)
//            .searchScopes($userSearchViewModel.searchScope) {
//                ForEach(SearchScope.allCases, id: \.self) { scope in
//                    Text(scope.rawValue.capitalized)
//                }
//            }
        }
    }
    
    private var backgroundImage: some View {
        VStack {
            Image("realistic-billboard")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    struct SearchBar: View {
        @Binding var text: String
        var onSearchButtonClicked: () -> Void

        var body: some View {
            HStack {
                TextField("Search", text: $text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                
                Button(action: {
                    self.onSearchButtonClicked()
                }) {
                    Text("Search")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                }
            }
        }
    }

    
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchView()
    }
}
