//
//  ChatLogViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/1/23.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

extension ChatLogView {
    @MainActor class ChatLogViewModel: ObservableObject {
        @Published var user = UserObservable.shared
        @Published var coreDataController = CoreDataController.shared
        @Published var chatText: String = ""
        let fbFirestoreHelper = FirebaseFirestoreHelper.shared
        let fbAuthHelper = FirebaseAuthHelper.shared
        let chatUser: FriendEntity?
        
        init(chatUser: FriendEntity?) {
            self.chatUser = chatUser
        }
        
        func handleSendMessage() {
            print(chatText)
            let fromId = user.id
            fbAuthHelper.auth.currentUser
        }
        
    }
}
