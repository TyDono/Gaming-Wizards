//
//  HomeView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/8/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
    @ObservedObject var searchSettingsViewModel = SearchSettingsViewModel()
    @ObservedObject var contactAndChatSettingsViewModel = ContactAndChatSettingsViewModel()
    @StateObject private var homeViewModel: HomeViewModel
    @EnvironmentObject var userAuth: UserAuth
    @State private var isViewPersonalAccountViewPopUp: Bool = false
    @State private var settingsIsActive: Bool = false
    @State private var isUserManagingAccountShown: Bool = false
    @State private var isShowingLogoutAlert: Bool = false
    @State private var isFriendListShowing: Bool = false
    @State private var isAccountSettingsShowing: Bool = false
    @State var isShowingEditAccountView: Bool = false
    @State private var isSearchSettingsShowing: Bool = false
    @State private var isContactAndChatSettingsShowing: Bool = false
    @State private var viewProfileTitleText: String? = ""
    @State private var viewProfileTitleImageString: String? = ""
    @State private var dismissButtonString: String? = "xmark"
    @State private var customNavTrailingButtonString: String? = nil
    
    init(homeViewModel: HomeViewModel = HomeViewModel()) {
        self._homeViewModel = StateObject(wrappedValue: homeViewModel)
    }
    
//    init(homeViewModel: HomeViewModel, userAuth: UserAuth) {
//        self._homeViewModel = EnvironmentObject(wrappedValue: homeViewModel)
//        self._userAuth = EnvironmentObject(wrappedValue: userAuth)
//    }
    
    var body: some View {
            ZStack(alignment: .bottom) {
                VStack {
                    List {
//                        manageFriendList // disabled until premium version added. post mvp
                        viewProfileButton
                        searchSettings
                        contactAndChatSettings
                        // accountSettingsButtonView // change fonts from normal and luminari. post mvp
                        logOutButton
                    }
                }
                .navigationBarTitle("Account", displayMode: .large)
                .alert(isPresented: $isShowingLogoutAlert) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text(""),
                        primaryButton: .default(Text("Logout")) {
                            Task {
                                await authenticationViewModel.signOut()
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationDestination(isPresented: $isShowingEditAccountView) {
                ManageAccountView()
            }
            .onAppear() {
                viewProfileTitleText = homeViewModel.user.title
            }
    }
    
    private var manageFriendList: some View {
        NavigationStack {
                Button(action: {
                    isFriendListShowing = true
                }) {
                    HStack {
                        /*
                        if Constants.friendRequestCount != 0 {
                            Text("\(Constants.friendRequestCount)")
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .fill(.red)
                                        .frame(width: 20, height: 20)
                                )
                        }
                        */
                        Image(systemName: "person.2")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Contact Info")
                            .badge(Constants.friendRequestCount)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
//                            .font(.custom(Constants.luminariRegularFontIdentifier, size: 20))
                            .font(.roboto(.regular, size: 20))
//                            .font(.roboto(.custom("luminri")))
//                            .font(.roboto(.semibold,
//                                          size: 20))
                        
                        Image(systemName: "chevron.right")
                            .frame(maxWidth: .infinity,
                                   alignment: .trailing)
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding()
        }
        .navigationDestination(isPresented: $isFriendListShowing) {
            FriendListView()
        }
    }
    
    private var contactAndChatSettings: some View {
        NavigationStack {
            Button(action: {
                isContactAndChatSettingsShowing = true
            }) {
                HStack {
                    Image(systemName: "person.2.badge.gearshape")
                        .resizable()
                        .frame(width: 23, height: 23)
                    Text(Constants.contactAndChatSettingsTitle)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .font(.roboto(.regular, size: 20))
                    
                    Image(systemName: "chevron.right")
                        .frame(maxWidth: .infinity,
                               alignment: .trailing)
                }
                .listRowInsets(EdgeInsets())
                .padding()
            }
        }
        .navigationDestination(isPresented: $isContactAndChatSettingsShowing) {
            ContactAndChatSettingsView(ContactAndChatSettingsVM: contactAndChatSettingsViewModel)
        }
    }
    
    private var searchSettings: some View {
        NavigationStack {
            Button(action: {
                isSearchSettingsShowing = true
            }) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Search Settings")
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .font(.roboto(.regular, size: 20))
                    
                    Image(systemName: "chevron.right")
                        .frame(maxWidth: .infinity,
                               alignment: .trailing)
                }
                .listRowInsets(EdgeInsets())
                .padding()
            }
        }
        .navigationDestination(isPresented: $isSearchSettingsShowing) {
            SearchSettingsView(searchSettingsVM: searchSettingsViewModel)
        }
    }
    

    
    private var viewProfileButton: some View {
        NavigationStack {
            Button(action: {
//                isUserManagingAccountShown = true
                isViewPersonalAccountViewPopUp = true
            }) {
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("View Profile")
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
//                        .font(.custom(Constants.luminariRegularFontIdentifier, size: 20))
                        .font(.roboto(.regular, size: 20))
                    
                    Image(systemName: "chevron.right")
                        .frame(maxWidth: .infinity,
                               alignment: .trailing)
                }
            }
            .listRowInsets(EdgeInsets())
            .padding()
        }
        .fullScreenCover(isPresented: $isViewPersonalAccountViewPopUp, content: {
            NavigationStack {
                ViewPersonalAccountView(isShowingEditAccountView: $isShowingEditAccountView)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            CustomNavigationTitle(titleImageSystemName: $viewProfileTitleImageString, titleText: $viewProfileTitleText)
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            CustomNavigationLeadingBarItem(leadingButtonAction: {
                                isViewPersonalAccountViewPopUp = false
                            }, leadingButtonString: $dismissButtonString)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            CustomNavigationTrailingItem(trailingButtonAction: {
                                
                            }, trailingButtonString: $customNavTrailingButtonString)
                        }
//                            CustomNavigationTitle(leadingButtonAction: {
//                                isViewPersonalAccountViewPopUp = false
//                            },
//                                                  leadingButtonString: $dismissButtonString,
//                                                  trailingButtonString: $customNavTrailingButtonString,
//                                                  titleImageSystemName: $viewProfileTitleImageString,
//                                                  titleText: $viewProfileTitleText)
//                        }
                    }
            }
        })
    }
    
    private var accountSettingsButtonView: some View {
        NavigationStack {
                Button(action: {
                    isAccountSettingsShowing = true
                }) {
                    HStack {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Settings")
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
//                            .font(.custom(Constants.luminariRegularFontIdentifier, size: 20))
                            .font(.roboto(.regular, size: 20))
                        
                        Image(systemName: "chevron.right")
                            .frame(maxWidth: .infinity,
                                   alignment: .trailing)
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding()
        }
        .navigationDestination(isPresented: $isAccountSettingsShowing) {
            AccountSettingsView()
        }
    }
    
    private var logOutButton: some View {
        Button(action: {
            isShowingLogoutAlert = true
        }) {
            HStack {
                Image(systemName: "door.right.hand.open")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Log Out")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
//                    .font(.custom(Constants.luminariRegularFontIdentifier, size: 20))
                    .font(.roboto(.regular, size: 20))
                
//                Image(systemName: "chevron.right")
//                    .frame(maxWidth: .infinity,
//                           alignment: .trailing)
            }
        }
//        .listRowInsets(EdgeInsets()) // un comment if you get a neato image for log out
        .padding()
        
//        HStack {
//            Button {
//
//            } label: {
//                Text("Log Out")
//                    .padding()
//                    .frame(maxWidth: .infinity,
//                           alignment: .leading)
//                    .font(.roboto(.semibold,
//                                  size: 20))
//            }
//        }
        
//        .fullScreenCover(isPresented: $isSettingsViewPresented, content: {
//            SettingsView()
//        })
        
//        Button(action: {
//            self.isSettingsViewPresented.toggle()
//        })
//        .fullScreenCover(isSettingsViewPresented: $isSettingsViewPresented, content: SettingsView.init)
//        {
//
//            Image("icons8-settings-144")
////                .aspectRatio(contentMode: .fit)
//        }
        
//        NavigationView {
//            NavigationLink(
//                destination: SettingsView(settingsIsActive: $settingsIsActive),
//                isActive: $settingsIsActive,
//                label: {
//                    Image("icons8-settings-144")
//                })
//        }
        //        Button(action: {
        ////            homeViewModel.changeViews()
//        }) {
//            Image("icons8-settings-144")
//        }
    }
    
}



//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
