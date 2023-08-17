//
//  SearchResultsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var user = UserObservable()
    @ObservedObject var user = UserObservable.shared
    @ObservedObject var userSearchViewModel: UserSearchViewModel
    @ObservedObject var searchResultsViewModel: SearchResultsViewModel
    @State var resultWasTapped: Bool = false
    @State var selectedUser: User = User(id: "110k1")
    @State var searchText: String
    @Binding var tabSelection: String
    
    init(tabSelection: Binding<String>, searchText: String) {
        self._tabSelection = tabSelection
        self._searchText = State(initialValue: searchText) // Initialize the @State property
        self.userSearchViewModel = UserSearchViewModel() // Initialize userSearchViewModel
        self.searchResultsViewModel = SearchResultsViewModel() // Initialize searchResultsViewModel
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                searchResultsList
            }
        }
        .font(.globalFont(.luminari, size: 16))
        .sheet(isPresented: $resultWasTapped, content: {
            SearchResultsDetailView(selectedUser: $selectedUser, specificGame: $searchText, tabSelection: $tabSelection)
        })
        .background(
            backgroundImage
        )
        .task {
            await searchResultsViewModel.performSearchForMatchingGames(gameName: searchText)
        }
    }
    
    private var searchResultsList: some View {
        List {
            let yourId = KeychainHelper.getUserID()
            ForEach(Array(searchResultsViewModel.users ?? []), id: \.self) { user in
                if user.id != yourId {
                    VStack {
                        Text(user.title ?? "")
                            .font(.globalFont(.luminari, size: 19))
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        HStack {
                            Text("Name: \(user.displayName ?? "")")
                        }
                        HStack {
                            Text("Location: \(user.location ?? "")")
                            Text("GroupSize: \(user.groupSize ?? "")")
                            //                        ForEach(user.games, id: \.self) { game in
                            //                            Text("Game: \(game)")
                            //                        }
                        }
                        HStack {
                            Text("Age: \(user.age ?? "")")
                            Text("Pay to Play: \(user.isPayToPlay ? "Yes" : "No")")
                        }
                    }
                    .listRowSeparator(.hidden)
                    .frame(alignment: .center)
                    .onTapGesture {
                        self.selectedUser = user
                        resultWasTapped = true
                    }
                }
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
                            .frame(width: geometry.size.width - 8, height: geometry.size.height - 8)
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
        
        return SearchResultsView(tabSelection: .constant("nil"), searchText: searchText)
    }
}
