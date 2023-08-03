//
//  DetailedFriendView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 3/21/23.
//

import SwiftUI

struct DetailedFriendView: View {
    @EnvironmentObject var friendListVM: FriendListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    friendDisplayNameView
                        .padding()
                    friendIDView
                        .padding()
                    //                isFavoriteView // implement this post MVP
                    //                    .padding()
                    
                    if friendListVM.friend?.isFriend == true {
                        removeFriendView
                            .padding()
                    } else {
                        HStack {
                            acceptFriendRequestView
                                .padding()
                            denyFriendRequestView
                                .padding()
                        }
                        
                    }
                }
                .buttonStyle(.borderless)
            }
            .toolbar {
            }
            .navigationBarTitle(friendListVM.friend?.displayName ?? "", displayMode: .large)
        }
        .keyboardAdaptive()
    }

    private var friendDisplayNameView: some View {
        VStack {
            Text(friendListVM.friend?.displayName ?? "")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 21))
        }
    }

    private var friendIDView: some View {
        VStack {
            Text("Personal ID")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 15))
            Text(friendListVM.friend?.friendCodeID ?? "")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 21))
        }
    }

    private var isFavoriteView: some View {
        VStack {
            Text("\(friendListVM.friend?.isFavorite == true ? "besties" : "just so you know, we aren't friends")")
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                .font(.roboto(.semibold,
                              size: 21))
        }
    }

    private var acceptFriendRequestView: some View {
        Button(action: {
            //perform action 
            friendListVM.acceptFriendRequest()
            //maybe have an animation that changes the view from "accept, deny" to "remove"
            if friendListVM.detailedFriendViewIsDismissed == true {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            VStack {
                Text("Accept")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .font(.roboto(.semibold,
                                  size: 21))
//                Image(systemName: "plus")
            }
        }
    }

    private var denyFriendRequestView: some View {
        Button(action: {
            friendListVM.denyFriendRequest()
            if friendListVM.detailedFriendViewIsDismissed == true {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            VStack {
                Text("Decline")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .font(.roboto(.semibold,
                                  size: 21))
                    .foregroundColor(.red)
//                Image(systemName: "plus")
            }
        }
    }

    private var removeFriendView: some View {
        Button(action: {
            friendListVM.removeFriend()
            if friendListVM.detailedFriendViewIsDismissed == true {
                self.presentationMode.wrappedValue.dismiss()
            }
        }) {
            VStack {
                Text("Remove")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .font(.roboto(.semibold,
                                  size: 21))
                    .foregroundColor(.red)
//                Image(systemName: "plus")
            }
        }

    }

}

struct DetailedFriendView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedFriendView()
    }
}
