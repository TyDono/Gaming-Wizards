//
//  ChatLogViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/1/23.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import Firebase

extension ChatLogView {
    @MainActor class ChatLogViewModel: ObservableObject {
        @Published var user = UserObservable.shared
        @Published var coreDataController = CoreDataController.shared
        @Published var chatText: String = ""
        @Published var errorMessage = ""
        @Published var chatMessages: [ChatMessage]
        @Published var sentChatText: String = ""
        @Published var counter: Int = 0
        private let firestoreService: FirebaseFirestoreService
//        let fbFirestoreHelper: FirebaseFirestoreHelper
        let fbAuthHelper = FirebaseAuthHelper.shared
        var chatUser: FriendEntity?
        
        init(
            firestoreService: FirebaseFirestoreService,
            chatMessages: [ChatMessage] = [ChatMessage](),
//            fbFirestoreHelper: FirebaseFirestoreHelper = FirebaseFirestoreHelper.shared,
            chatUser: FriendEntity?
        ) {
            
            self.chatMessages = chatMessages
//            self.fbFirestoreHelper = fbFirestoreHelper
            self.firestoreService = firestoreService
            self.chatUser = chatUser
            /*
            if let unwrappedChatUser = chatUser {
                self.chatUser = unwrappedChatUser
                callFetchMessages(chatUser: unwrappedChatUser)
            } else {
                self.chatUser = chatUser
            }
             */
        }
        
        func callFetchMessages(chatUser: FriendEntity) {
            guard let chatUser = chatUser.id else { return }
            firestoreService.fetchMessages(fromId: user.id, toId: chatUser) { [weak self] err, chatMessage in
                guard let self = self else { return }
                self.chatMessages.append(chatMessage)
                DispatchQueue.main.async {
                    self.counter += 1
                }
            }
        }
        
        func callHandelSendMessage(chatUser: FriendEntity) async {
            guard let chatUserId = chatUser.id else { return }
            sentChatText = chatText
            chatText = ""
            counter += 1
            do {
                try await firestoreService.handleSendMessage(toId: chatUserId, fromId: user.id, chatText: sentChatText)
            } catch {
                self.errorMessage = "Failed to send the message" // error.localizedDescription
            }
        }
        
    }
}
