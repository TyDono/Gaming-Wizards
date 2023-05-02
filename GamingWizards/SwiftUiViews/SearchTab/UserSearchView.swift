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
    var invitations = [Invitation]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(userSearchViewModel.filteredMessages) { message in
                    VStack(alignment: .leading) {
                        Text(message.user)
                            .font(.headline)
                        
                        Text(message.text)
                    }
                }
            }
            .navigationTitle("Invitations")
        }
        .searchable(text: $userSearchViewModel.searchText)
        .searchScopes($userSearchViewModel.searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
        .onAppear(perform: userSearchViewModel.runSearch)
        .onSubmit(of: .search, userSearchViewModel.runSearch)
        .onChange(of: userSearchViewModel.searchScope) { _ in userSearchViewModel.runSearch() }
    }
    
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        UserSearchView()
    }
}
