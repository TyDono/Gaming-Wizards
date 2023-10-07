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
                    ForEach(blockedUsersVM.coreDataController.blockedUserEntities, id: \.self) { blockedUser in
                        Button {
                            isUnblockUserAlertShowing = true
                        } label: {
                            Text(blockedUser.displayName ?? "")
                        }
                        .alert(isPresented: $isUnblockUserAlertShowing) {
                            Alert(
                                title: Text("Are you sure you want to unblock this user?"),
                                message: Text(""),
                                primaryButton: .default(Text("Unblock")) {
                                    Task {
                                        await blockedUsersVM.callUnblockUser(blockedUser: blockedUser)
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
