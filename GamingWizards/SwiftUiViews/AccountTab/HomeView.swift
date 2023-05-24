//
//  HomeView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/8/22.
//

import SwiftUI

struct HomeView: View {
    
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var userAuth: UserAuth
    @State var settingsIsActive: Bool = false
    @State private var isUserManagingAccountShown: Bool = false
    @State private var isShowingLogoutAlert: Bool = false
    @State private var isFriendListShowing: Bool = false
    
    var body: some View {
            ZStack(alignment: .bottom) {
                VStack {
                    List {
                        manageFriendList
                        manageAccountButton
                        logOutButton
                    }
                }
                .navigationBarTitle("Account", displayMode: .large)
                .alert(isPresented: $isShowingLogoutAlert) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text(""),
                        primaryButton: .default(Text("Logout")) {
                            authenticationViewModel.signOut()
                        },
                        secondaryButton: .cancel()
                    )
                }
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
                        Text("Friends")
                            .badge(Constants.friendRequestCount)
                            .frame(maxWidth: .infinity,
                                   alignment: .leading)
                            .font(.custom(Constants.luminariRegularFontIdentifier,
                                          size: 20))
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
    
    private var manageAccountButton: some View {
        NavigationStack {
            Button(action: {
                isUserManagingAccountShown = true
            }) {
                HStack {
                    Image(systemName: "gearshape")
                    Text("Manage Account")
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .font(.custom(Constants.luminariRegularFontIdentifier,
                                      size: 20))
                    
                    Image(systemName: "chevron.right")
                        .frame(maxWidth: .infinity,
                               alignment: .trailing)
                }
            }
            .listRowInsets(EdgeInsets())
            .padding()
        }
        .navigationDestination(isPresented: $isUserManagingAccountShown) {
            ManageAccountView()
        }
    }
    
    private var logOutButton: some View {
        Button(action: {
            isShowingLogoutAlert = true
        }) {
            HStack {
//                Image(systemName: "person.2")
                Image(systemName: "door.right.hand.open")
                Text("Log Out")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .font(.custom(Constants.luminariRegularFontIdentifier,
                                  size: 20))
                
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



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
