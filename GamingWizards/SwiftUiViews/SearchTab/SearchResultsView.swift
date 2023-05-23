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
                timmin
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
            ForEach(Array(searchResultsViewModel.users ?? []), id: \.self) { user in
                VStack {
                    Text(user.displayName)
                        .font(.luminari(.regular, size: 24))
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    HStack {
                        Text("Location: \(user.location)")
                        Text("GroupSize: \(user.groupSize)")
                        Text("Age: \(user.age)")
                        //pat to play here
                        ForEach(user.games, id: \.self) { game in
                            Text("Game: \(game)")
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .frame(alignment: .center)
                .onTapGesture {
                    self.selectedUser = user
                    resultWasTapped = true
                }
//                .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
            .listRowBackground(
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.clear)
                            .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                        
                        Image("blank-page")
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                    .alignmentGuide(HorizontalAlignment.center) { _ in
                        geometry.size.width / 2
                    }
                }
            )
            
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
