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
        let fbAuthHelper = FirebaseAuthHelper.shared
        var chatUser: FriendEntity?
        var reportedUser: User
        
        init(
            firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper(),
            chatMessages: [ChatMessage] = [ChatMessage](),
            chatUser: FriendEntity?
//            reportedUser: User
        ) {
            
            self.chatMessages = chatMessages
            self.firestoreService = firestoreService
            self.chatUser = chatUser
            self.reportedUser = User(
                    id: chatUser?.id ?? "",
                    firstName: nil,
                    lastName: nil,
                    displayName: chatUser?.displayName ?? "",
                    email: nil,
                    latitude: nil,
                    longitude: nil,
                    location: nil,
                    profileImageString: "",
//                    friendCodeID: "",
                    listOfGames: nil,
                    groupSize: nil,
                    age: nil,
                    about: nil,
                    availability: nil,
                    title: nil,
                    isPayToPlay: false,
                    isSolo: false
                )
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
        
        func convertFriendEntityToReportedUser(friend: FriendEntity, completion: @escaping (User) -> Void) {
            DispatchQueue.global().async {
                let user = User(id: friend.id!, firstName: "", lastName: "", displayName: friend.displayName, email: "", latitude: 0.0, longitude: 0.0, location: "", profileImageString: "", listOfGames: [""], groupSize: "", age: "", about: "", availability: "", title: "", isPayToPlay: false, isSolo: false)
                DispatchQueue.main.async {
                    completion(user)
                }
            }
        }
        
        func callHandelSendMessage(chatUser: FriendEntity) async {
            guard let chatUserId = chatUser.id else { return }
            sentChatText = chatText
            chatText = ""
            counter += 1
            do {
                try await firestoreService.handleSendMessage(toId: chatUserId, chatUserDisplayName: chatUser.displayName ?? "", fromId: user.id, chatText: sentChatText)
                try await firestoreService.persistRecentMessage(toId: chatUserId, chatUserDisplayName: chatUser.displayName ?? "", fromId: user.id, chatText: sentChatText)
            } catch {
                self.errorMessage = "Failed to send the message" // error.localizedDescription
            }
        }
        
    }
}
