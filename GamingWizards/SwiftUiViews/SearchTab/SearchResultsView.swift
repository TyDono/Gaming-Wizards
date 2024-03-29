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
    @State private var isCreateReportUserViewPresented: Bool = false
    @Binding var tabSelection: String
    @Binding var searchText: String
    @State private var isSearchResultsViewPresented: Bool = false
    
    init(
        searchResultsVM: SearchResultsViewModel,
        tabSelection: Binding<String>,
        searchText: Binding<String>
//        isSearchResultsViewPresented: State<Bool>
    ) {
        self._tabSelection = tabSelection
        self._searchText = searchText
        self._searchResultsVM = StateObject(wrappedValue: searchResultsVM)
//        self._isSearchResultsViewPresented = isSearchResultsViewPresented
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                if ((searchResultsVM.searchedForUsers?.isEmpty) == true) {
                    noSearchResults
                } else {
                    searchResultsList
                }
            }
            .onAppear {
                Task {
                    await searchResultsVM.callForCoreDatsEntities()
                    searchResultsVM.searchedForUsers = []
                    guard let isPayToPlaySearchSettings = searchResultsVM.savedSearchSettingsEntity?.isPayToPlay else { return }
                    await searchResultsVM.searchForMatchingUsers(gameName: searchText, isPayToPlay: isPayToPlaySearchSettings)
                }
            }
            .onDisappear {
                searchResultsVM.cancelFriendEntities()
                searchResultsVM.cancelSearchSettings()
                searchResultsVM.cancelBlockedUserEntities()
            }
        }
//        .font(.globalFont(.luminari, size: 16))
//        .font(.roboto(.regular, size: 16))
        .fullScreenCover(isPresented: $searchResultsVM.resultWasTapped, content: {
            NavigationStack {
                SearchResultsDetailView(selectedUser: $searchResultsVM.selectedUser,
                                        specificGame: $searchText,
                                        tabSelection: $tabSelection,
                                        isSearchResultsViewPresented: $isSearchResultsViewPresented)
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
                let blockedUserData: [String: Any] = [
                    Constants.idStringValue: searchResultsVM.selectedUser.id,
                    Constants.displayName: searchResultsVM.selectedUser.displayName ?? "",
                    Constants.dateRemoved: Date()
                ]
                CreateReportUserView(
//                    presentationMode: self.presentationMode,
                    isCreateReportUserViewPresented: $isCreateReportUserViewPresented,
                    reporterId: $searchResultsVM.user.id,
                    reportedUser: $searchResultsVM.selectedUser,
                    chatRoomId: $searchResultsVM.selectedUser.id,
                    blockedUser: .constant(BlockedUser(data: blockedUserData)),
                    friendEntity: searchResultsVM.convertUserToFriendDataBinding(
                        displayName: searchResultsVM.selectedUser.displayName ?? "",
                        friendUserID: searchResultsVM.selectedUser.id,
                        profileImageString: searchResultsVM.selectedUser.profileImageString,
                        isFavorite: false,
                        isFriend: false,
                        recentMessageText: "",
                        recentMessageTimeStamp: Date(),
                        onlineStatus: false,
                        messageToId: ""),
                    isSearchResultsViewPresented: $isSearchResultsViewPresented,
                    isChatLogViewPresented: .constant(false)
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
            ForEach(Array(searchResultsVM.searchedForUsers ?? []), id: \.self) { user in
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
//struct SearchResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsView(tabSelection: .constant("someTabSelection"), searchText: .constant("someSearchText"))
//            .preferredColorScheme(.light) // You can adjust the color scheme as needed
//    }
//}
