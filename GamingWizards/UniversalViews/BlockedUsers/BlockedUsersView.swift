//
//  BlockedUsersView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/4/23.
//

import SwiftUI

struct BlockedUsersView: View {
    @StateObject var blockedUsersVM: BlockedUsersViewModel
    
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
                
                Text("Blocked Users")
            }
        }
    }
    
}
