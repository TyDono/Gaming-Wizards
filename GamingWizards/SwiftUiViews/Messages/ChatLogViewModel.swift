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
        let fbFirestoreHelper = FirebaseFirestoreHelper.shared
        let fbAuthHelper = FirebaseAuthHelper.shared
        let chatUser: FriendEntity?
        
        init(chatUser: FriendEntity?) {
            self.chatUser = chatUser
        }
        
        func handleSendMessage() {
            let fromId = user.id
            guard let toId = chatUser?.id else { return }
            let senderMessageDocumentPath = fbFirestoreHelper.firestore
                .collection("messages")
                .document(fromId)
                .collection(toId)
                .document()
            let messageData = ["fromId": fromId,
                               "toId": toId,
                               "text": self.chatText,
                               "timeStamp": Timestamp()] as [String : Any]
            senderMessageDocumentPath.setData(messageData) { err in
                if let error = err {
                    print("ERROR SETTING DATA IN THE MESSAGE CHAT LOG: \(error.localizedDescription)")
                    self.errorMessage = "Failed to send message"
                    return
                }
            }
            self.chatText = ""
            
            let recipientMessageDocumentPath = fbFirestoreHelper.firestore
                .collection("messages")
                .document(toId)
                .collection(fromId)
                .document()
            recipientMessageDocumentPath.setData(messageData) { err in
                if let error = err {
                    print("ERROR SETTING DATA IN THE MESSAGE CHAT LOG: \(error.localizedDescription)")
                    self.errorMessage = "Failed to send message"
                    return
                }
                
            }
        }
        
    }
}
