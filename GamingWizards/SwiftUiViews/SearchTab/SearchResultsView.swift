//
//  SearchResultsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var searchResultsVM: SearchResultsViewModel
    @State private var viewProfileTitleText: String? = ""
    @State private var viewProfileTitleImageString: String? = ""
    @State private var dismissButtonString: String? = "xmark"
    @State private var customNavTrailingButtonString: String? = "exclamationmark.bubble"
    @Binding var tabSelection: String
    @Binding var searchText: String
    
    init(
        searchResultsVM: SearchResultsViewModel = SearchResultsViewModel(),
        tabSelection: Binding<String>,
        searchText: Binding<String>
    ) {
        self._tabSelection = tabSelection
        self._searchText = searchText
        self._searchResultsVM = StateObject(wrappedValue: searchResultsVM)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                if ((searchResultsVM.users?.isEmpty) == true) {
                    noSearchResults
                } else {
                    searchResultsList
                }
            }
            .onAppear {
                Task {
                    await searchResultsVM.searchForMatchingUsers(gameName: searchText, isPayToPlay: searchResultsVM.coreDataController.savedSearchSettingsEntity?.isPayToPlay ?? true)
                }
            }
        }
//        .font(.globalFont(.luminari, size: 16))
//        .font(.roboto(.regular, size: 16))
        .fullScreenCover(isPresented: $searchResultsVM.resultWasTapped, content: {
            NavigationStack {
                SearchResultsDetailView(selectedUser: $searchResultsVM.selectedUser, specificGame: $searchText, tabSelection: $tabSelection)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            CustomNavigationTitle(titleImageSystemName: $viewProfileTitleImageString, titleText: $viewProfileTitleText)
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            CustomNavigationLeadingBarItem(leadingButtonAction: {
                                searchResultsVM.resultWasTapped.toggle()
                            }, leadingButtonString: $dismissButtonString)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            CustomNavigationTrailingItem(trailingButtonAction: {
                                searchResultsVM.isCreateReportUserViewShowing.toggle()
                            }, trailingButtonString: $customNavTrailingButtonString)
                        }
                    }
            }
            .sheet(isPresented: $searchResultsVM.isCreateReportUserViewShowing) {
                CreateReportUserView(presentationMode: self.presentationMode,
                                     reporterId: $searchResultsVM.user.id,
                                     reportedUser: $searchResultsVM.selectedUser,
                                     chatRoomId: $searchResultsVM.selectedUser.id,
                                     blockedUser: .constant(BlockedUser(id: searchResultsVM.selectedUser.id,
                                                                        displayName: searchResultsVM.selectedUser.displayName ?? "",
                                                                        dateRemoved: Date())),
                                     friendEntity: searchResultsVM.convertUserToFriendDataBinding(
                                        displayName: searchResultsVM.selectedUser.displayName ?? "",
                                        friendUserID: searchResultsVM.selectedUser.id,
                                        profileImageString: searchResultsVM.selectedUser.profileImageString,
                                        isFavorite: false,
                                        isFriend: false)
                )
            }
        })
        .background(
//            Color(.init(white: 1.0, alpha: 1))
            /*
            backgroundImage
             */
        )
    }
    
    private var noSearchResults: some View {
        VStack {
            Spacer()
            Text("No Matches Found :(")
                .font(.roboto(.regular, size: 26))
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity)
        }
    }
    
    private var searchResultsList: some View {
        List {
            ForEach(Array(searchResultsVM.users ?? []), id: \.self) { user in
                VStack {
                    Text(user.title ?? "")
                        .font(.roboto(.regular, size: 19))
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    HStack {
                        Text("Name: \(user.displayName ?? "")")
                    }
                    HStack {
                        Text("Location: \(user.location ?? "")")
                        Text("GroupSize: \(user.groupSize ?? "")")
                    }
                    HStack {
                        Text("Age: \(user.age ?? "")")
                        Text("Pay to Play: \(user.isPayToPlay ? "Yes" : "No")")
                    }
                }
                .listRowSeparator(.hidden)
                .frame(alignment: .center)
                .background(
                    GeometryReader { geometry in
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: Constants.roundedCornerRadius)
                                .foregroundColor(Color(.systemGray6))
                            
                        }
                        .alignmentGuide(HorizontalAlignment.center) { _ in
                            geometry.size.width / 2
                        }
                    }
                )
                .onTapGesture {
                    viewProfileTitleText = user.title
                    searchResultsVM.selectedUser = user
                    searchResultsVM.resultWasTapped = true
                }
            }
        }
        .listStyle(PlainListStyle())
        .background(
            Color.clear
        )
    }

    
    private var backgroundImage: some View {
        Image("blank-wood")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
    
}

import SwiftUI

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(tabSelection: .constant("someTabSelection"), searchText: .constant("someSearchText"))
            .preferredColorScheme(.light) // You can adjust the color scheme as needed
    }
}
