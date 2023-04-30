//
//  FriendsListView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 11/21/22.
//

import SwiftUI
import Combine

struct FriendListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var friendListVM = FriendListViewModel()
    @StateObject var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
    @StateObject var coreDataController = CoreDataController.shared
    
    var body: some View {
            //            ZStack(alignment: .bottom) {
            VStack {
//                ForEach(authenticationViewModel.myFriendListData) { friendData in
//                    Text("\(friendData.friendDisplayName)")
//                }
                listOfFriends
            }
            .onAppear {
                authenticationViewModel.retrieveFriendsListener()
            }
            .onDisappear {
                authenticationViewModel.stopListening()
            }
            //            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addFriendButton
                }
            }
            .navigationBarTitle("Friend List", displayMode: .large)
            .alert("Cannot Send", isPresented: $friendListVM.FriendRequestAlreadySentIsTrue, actions: {
                Button("OK", role: .cancel, action: {})
            }, message: {
                Text("Your friend request is still pending, or you are already friends")
            })
            
        }
    
    private var listOfFriends: some View {
        VStack {
            List {
                
//                ForEach(authenticationViewModel.myFriendListData) { friendData in
//                    Text("\(friendData.friendDisplayName)")
//                }
//
//                ForEach(coreDataController.savedFriendEntities) { friendData in
//                    Text("\(friendData.friendDisplayName)")
//                }
                
                ForEach(coreDataController.savedFriendEntities, id: \.self) { friend in
                    HStack {
                        NavigationLink {
                            DetailedFriendView()
                                .environmentObject(friendListVM)
                                .onAppear {
                                    friendListVM.friendWasTapped(friend: friend)
                                }
                        } label: {
                            if friend.isFriend == false {
                                redCircle
                            }
                            Text(friend.friendDisplayName ?? "")
                        }
                    }
                }
            }
        }
    }
    
    //not used
    private var customNavigationBar: some View {
        ZStack {
            HStack {
                backButton
                Spacer()
                addFriendButton
            }
        }
    }
    
    private var addFriendButton: some View {
        Button(action: {
            friendListVM.addFriendAlertIsShowing = true
        }) {
            HStack {
                Image(systemName: "plus")
            }
            .alert("Add Friend", isPresented: $friendListVM.addFriendAlertIsShowing, actions: {
                TextField("Friend ID", text: $friendListVM.friendIDTextField)
                Button("Submit", action: {
                    guard !friendListVM.friendIDTextField.isEmpty else {
                        friendListVM.noFriendExistsAlertIsShowing = true
                        return
                    }
                    friendListVM.sendFriendRequest()
                    //friendListVM.addFruit() // remove later
                    //friendListVM.friendIDTextField = ""
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Please Enter friend ID of requested friend")
            })
        }
        .alert("Cannot Send", isPresented: $friendListVM.noFriendExistsAlertIsShowing, actions: {
            Button("OK", role: .cancel, action: {})
        }, message: {
            Text("there is no friend who has this friend ID")
        })

    }
    
    private var redCircle: some View {
        Circle()
            .fill(.red)
            .frame(width: 13, height: 13)
            .glow(color: .red,
                  radius: 3)
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .renderingMode(.template)
                .resizable()
                .scaledToFill()
                .frame(width: 15,
                       height: 15)
                .foregroundColor(.black)
                .padding(.top, 15)
                .padding(.leading, 25)
        }
    }
    
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
