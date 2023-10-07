//
//  BlockedUsersView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/4/23.
//

import SwiftUI

struct BlockedUsersView: View {
    @StateObject var blockedUsersVM: BlockedUsersViewModel
    @State var isUnblockUserAlertShowing: Bool = false
    @State var fbFirestore = FirebaseFirestoreHelper.shared
    @State var user = UserObservable.shared
    
    init(blockedUsersVM: BlockedUsersViewModel) {
        self._blockedUsersVM = StateObject(wrappedValue: blockedUsersVM)
    }
    
    var body: some View {
        ZStack {
            VStack {
                listOfBlockedUsers
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(Constants.blockedUsersTitle)
                        .font(.globalFont(.luminari, size: 26))
                        .foregroundColor(.primary)
                }
            }
        }
       
    }
    
    private var listOfBlockedUsers: some View {
        ZStack {
            VStack {
                List {
                    ForEach(Array(blockedUsersVM.coreDataController.blockedUserEntities.sorted(by: { $0.displayName ?? "" < $1.displayName ?? "" }).enumerated()), id: \.element.id) { index, blockedUser in
                        Button {
                            isUnblockUserAlertShowing = true
                            blockedUsersVM.selectedUsedToUnblock = blockedUser
                        } label: {
                            HStack {
                                Image(systemName: "x.circle")
                                    .font(.system(size: 16))
                                    .foregroundStyle(Color.red)
                                Text(blockedUser.displayName ?? "")
                                    .font(.system(size: 16))
                            }
                        }
                        .alert(isPresented: $isUnblockUserAlertShowing) {
                            Alert(
                                title: Text("Are you sure you want to unblock this user?"),
                                message: Text(""),
                                primaryButton: .default(Text("Unblock")) {
                                    Task {
                                        await blockedUsersVM.callUnblockUser(blockedUser: blockedUsersVM.selectedUsedToUnblock!)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
           
        }
    }
    
}
