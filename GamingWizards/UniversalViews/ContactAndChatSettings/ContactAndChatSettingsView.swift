//
//  ContactAndChatSettingsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/4/23.
//

import SwiftUI

struct ContactAndChatSettingsView: View {
    @StateObject var contactAndChatSettingsVM: ContactAndChatSettingsViewModel
    @ObservedObject var blockedUsersVM = BlockedUsersViewModel()
    @State var isBlockedUsersViewShowing: Bool = false
    
    init(ContactAndChatSettingsVM: ContactAndChatSettingsViewModel) {
        self._contactAndChatSettingsVM = StateObject(wrappedValue: ContactAndChatSettingsVM)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                List {
                    blockedUser
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(Constants.contactAndChatSettingsTitle)
                    .font(.globalFont(.luminari, size: 26))
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var blockedUser: some View {
        NavigationStack {
            Button(action: {
                isBlockedUsersViewShowing = true
            }) {
                HStack {
                    blockedUsersImage
                    Text(Constants.blockedUsersTitle)
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
        .navigationDestination(isPresented: $isBlockedUsersViewShowing) {
            BlockedUsersView(blockedUsersVM: blockedUsersVM)
        }
        
    }
    
    private var blockedUsersImage: some View {
        ZStack {
            Image(systemName: "nosign")
                .resizable()
                .frame(width: 26, height: 26)
            
            Image(systemName: "person.2")
                .resizable()
                .frame(width: 18, height: 18)
        }
    }
    
}

