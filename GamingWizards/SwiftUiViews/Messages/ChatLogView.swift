//
//  DetailedMessageView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/1/23.
//

import SwiftUI

struct ChatLogView: View {
    @Binding var presentationMode: PresentationMode
    
    @StateObject private var chatLogVM: ChatLogViewModel
    @State private var MessageBarTextEditorPlaceholder: String = "Description"
    let chatUser: FriendEntity?
//    @State private var reportedUser: User!
    
    private let chatLogScrollToString: String = "Empty"
    
    init(
        presentationMode: Binding<PresentationMode>,
         chatUser: FriendEntity?
    ) {
        self._presentationMode = presentationMode
        self.chatUser = chatUser
        self._chatLogVM = StateObject(wrappedValue: ChatLogViewModel(chatUser: chatUser))
//        self.chatLogVM = .init(chatUser: chatUser)
    }
    
    var body: some View {
        ZStack {
            VStack {
                messagesView
                Text(chatLogVM.errorMessage)
            }
        }
        .navigationTitle(chatUser?.displayName ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(chatUser?.displayName ?? "")
        .navigationBarItems(trailing: HStack {
            gearButtonView
        })
        .task {
            guard let unwrappedChatUser = self.chatUser else { return }
            chatLogVM.callFetchMessages(chatUser: unwrappedChatUser)
        }
    }
    
    private var bottomChatBarView: some View {
        HStack(spacing: 16) {
            ZStack {
                
                if chatLogVM.chatText.isEmpty {
                    TextEditor(text: $MessageBarTextEditorPlaceholder)
                        .foregroundColor(.gray)
                        .disabled(true)
                        .frame(height: 50)
                }
                TextEditor(text: $chatLogVM.chatText.max(Constants.textViewMaxCharacters))
                    .opacity(chatLogVM.chatText.isEmpty ? 0.25 : 1)
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            Button {
                Task {
                    guard let unwrappedChatUser = chatUser else { return }
                    await chatLogVM.callHandelSendMessage(chatUser: unwrappedChatUser)
                }
            } label: {
                Text("Send")
                    .foregroundColor(.white)
                    .background(Color.clear)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(Constants.semiRoundedCornerRadius)
        }
        .background(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private var gearButtonView: some View {
        //            let reportedUser = chatLogVM.convertFriendEntityToReportedUser(friend: chatUser!)
        CreateReportUserView(
            presentationMode: self.$presentationMode,
            reporterId: $chatLogVM.user.id,
            reportedUser: Binding(get: { chatLogVM.reportedUser }, set: { _ in }),
            chatRoomId: Binding<String>( get: { chatLogVM.reportedUser.id }, set: { _ in }),
            blockedUser: .constant(BlockedUser(blockedUserId: chatLogVM.reportedUser.id,
                                               displayName: chatLogVM.reportedUser.displayName ?? "",
                                               dateRemoved: Date())),
            friendEntity: Binding<FriendEntity>( get: { chatUser! }, set: { _ in })
        )
        
    }
    
    private var messagesView: some View {
        VStack {
            ScrollView {
                ScrollViewReader { ScrollViewProxy in
                    VStack {
                        ForEach(chatLogVM.chatMessages, id: \.self) { message in
                            MessageView(message: message)
                        }
                        HStack { Spacer() }
                        .id(chatLogScrollToString)
                    }
                    .onReceive(chatLogVM.$counter) { _ in
                        withAnimation(.easeInOut(duration: 0.5)) {
                            ScrollViewProxy.scrollTo(chatLogScrollToString, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color(.init(white: 0.95, alpha: 1)))
            .safeAreaInset(edge: .bottom) {
                bottomChatBarView
                    .background(Color(
                        .systemBackground)
                        .ignoresSafeArea())
            }
        }
    }
    
}
