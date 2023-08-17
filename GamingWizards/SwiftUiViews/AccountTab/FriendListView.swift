//
//  FriendsListView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 11/21/22.
//

import SwiftUI

struct FriendListView: View {
    @Environment(\.presentationMode) var presentationMode
      @ObservedObject var friendListVM: FriendListViewModel
      @ObservedObject var authenticationViewModel: AuthenticationViewModel
      @ObservedObject var coreDataController: CoreDataController
      @ObservedObject var fbFirestoreHelper: FirebaseFirestoreHelper

    init(
        friendListVM: FriendListViewModel = .init(user: UserObservable.shared),
        authenticationViewModel: AuthenticationViewModel = .sharedAuthenticationVM,
        coreDataController: CoreDataController = .shared,
        fbFirestoreHelper: FirebaseFirestoreHelper = .shared
    ) {
        self.friendListVM = friendListVM
        self.authenticationViewModel = authenticationViewModel
        self.coreDataController = coreDataController
        self.fbFirestoreHelper = fbFirestoreHelper
      }
    
    var body: some View {
        ZStack {
            VStack {
                listOfFriends
            }
            .onAppear {
                fbFirestoreHelper.retrieveFriendsListener(user: friendListVM.user)
//                authenticationViewModel.retrieveFriendsListener()
            }
            .onDisappear {
                fbFirestoreHelper.stopListening()
//                authenticationViewModel.stopListening()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addFriendButton
                }
            }
            .navigationBarTitle("Contact List", displayMode: .large)
            .alert("Cannot Send", isPresented: $friendListVM.FriendRequestAlreadySentIsTrue, actions: {
                Button("OK", role: .cancel, action: {})
            }, message: {
                Text("Your friend request is still pending, or you are already friends")
            })
        }
    }
    
    private var listOfFriends: some View {
        VStack {
            List {
                
//                ForEach(authenticationViewModel.myFriendListData) { friendData in
//                    Text("\(friendData.displayName)")
//                }
//
//                ForEach(coreDataController.savedFriendEntities) { friendData in
//                    Text("\(friendData.displayName)")
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
                            Text(friend.displayName ?? "")
                        }
                    }
                }
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
                TextField("Friend ID", text: $friendListVM.friendCodeIDTextField)
                Button("Submit", action: {
                    guard !friendListVM.friendCodeIDTextField.isEmpty else {
                        friendListVM.noFriendExistsAlertIsShowing = true
                        return
                    }
                    friendListVM.sendFriendRequest()
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

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView(
            friendListVM: FriendListViewModel(user: UserObservable.shared),
            authenticationViewModel: AuthenticationViewModel.sharedAuthenticationVM,
            coreDataController: CoreDataController.shared,
            fbFirestoreHelper: FirebaseFirestoreHelper.shared
        )
    }
}

