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
        .task {
            await blockedUsersVM.callCoreDataEntities()
        }
        .onAppear {
            blockedUsersVM.cancelBlockedUserEntities()
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
        .alert(isPresented: $isUnblockUserAlertShowing) {
            // This alert will appear when `isUnblockUserAlertShowing` is set to true
            Alert(
                title: Text("Are you sure you want to unblock \(blockedUsersVM.selectedUsedToUnblock?.displayName ?? "this user?")"),
                message: Text(""),
                primaryButton: .default(Text("Unblock")) {
                    Task {
                        if let userToUnblock = blockedUsersVM.selectedUsedToUnblock {
                            await blockedUsersVM.callUnblockUser(blockedUser: userToUnblock)
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var listOfBlockedUsers: some View {
        VStack {
            List {
                ForEach(Array(blockedUsersVM.blockedUserEntities.sorted(by: { $0.dateRemoved! < $1.dateRemoved! }).enumerated()), id: \.element.id) { index, blockedUser in
                    Button {
                        isUnblockUserAlertShowing = true
                        blockedUsersVM.selectedUsedToUnblock = blockedUser
                    } label: {
                        HStack {
                            Image(systemName: "x.circle")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.red)
                            Text(blockedUser.displayName ?? "")
                                .font(.system(size: 20))
                        }
                    }
                }
            }
            .animation(Animation.easeInOut(duration: 0.2), value: blockedUsersVM.blockedUserEntities)
        }
    }
}
