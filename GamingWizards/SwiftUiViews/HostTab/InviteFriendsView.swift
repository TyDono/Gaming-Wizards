//
//  InviteView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 10/4/22.
//

import SwiftUI
import CoreData
import Firebase

struct InviteFriendsView: View {
    @StateObject var coreDataController = CoreDataController.shared
    
    var body: some View {
        VStack {
            List {
                ForEach(coreDataController.savedFriendEntities, id: \.self) { friend in
                    HStack {
                        NavigationLink {
//                            DetailedFriendView()
//                                .environmentObject(friendListVM)
//                                .onAppear {
//                                    friendListVM.friendWasTapped(friend: friend)
//                                }
                        } label: {
                            if friend.isFriend == false {
                                Text(friend.friendDisplayName ?? "")
                                //have the VM contain a list of friend entities that are friends only
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DeliveryDriverView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendsView()
    }
}
