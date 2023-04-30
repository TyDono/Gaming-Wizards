//
//  OrderView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 10/6/22.
//

import SwiftUI

struct InvitationView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var invitationViewModel: InvitationViewModel = InvitationViewModel()
    var invitations = [Invitation]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(invitationViewModel.filteredMessages) { message in
                    VStack(alignment: .leading) {
                        Text(message.user)
                            .font(.headline)
                        
                        Text(message.text)
                    }
                }
            }
            .navigationTitle("Invitations")
        }
        .searchable(text: $invitationViewModel.searchText)
        .searchScopes($invitationViewModel.searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
        .onAppear(perform: invitationViewModel.runSearch)
        .onSubmit(of: .search, invitationViewModel.runSearch)
        .onChange(of: invitationViewModel.searchScope) { _ in invitationViewModel.runSearch() }
    }
    
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationView()
    }
}
