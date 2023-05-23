//
//  SearchResultsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userSearchViewModel: UserSearchViewModel
    @StateObject var searchResultsViewModel = SearchResultsViewModel()
    @State var resultWasTapped: Bool = false
    @State var selectedUser: User = User(id: "110k1")
    @State var searchText: String
    
    var body: some View {
        ZStack {
            NavigationView {
                searchResultsList
            }
        }
        .font(.luminari(.regular, size: 16))
        .navigationDestination(isPresented: $resultWasTapped) {
            SearchResultsDetailView(selectedUser: $selectedUser, specificGame: $searchText)
       }
        .background(
            backgroundImage
        )
        .onAppear {
            searchResultsViewModel.callPerformSearchForMatchingGames(gameName: searchText)
        }
    }
    
    private var searchResultsList: some View {
        List {
            ForEach(searchResultsViewModel.users ?? [], id: \.self) { user in
                VStack {
                    Text(user.displayName)
                    HStack {
                        ForEach(user.games, id: \.self) { game in
                            Text(game)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .frame(alignment: .center)
//                .padding(.vertical, 16)
                .onTapGesture {
                    self.selectedUser = user
                    resultWasTapped = true
                }
            }
//            .environment(\.defaultMinListRowHeight, 50)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    .foregroundColor(.white)
                    .padding(
                        EdgeInsets(
                            top: 2,
                            leading: 6,
                            bottom: 2,
                            trailing: 6
                        )
                    )
            )
//            .listRowBackground(
//                Color.red
////                Image("blank-page")
////                    .resizable()
////                    .scaledToFit()
////                    .edgesIgnoringSafeArea(.all)
//            )

        }
        .listStyle(PlainListStyle())
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
        let userSearchViewModel = UserSearchViewModel()
        let searchText = "Example Search"
        let selectedUser = User(id: "110k1")
        
        return SearchResultsView(userSearchViewModel: userSearchViewModel, selectedUser: selectedUser, searchText: searchText)
    }
}
