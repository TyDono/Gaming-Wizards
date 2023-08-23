//
//  DetailedMessageView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/1/23.
//

import SwiftUI

struct ChatLogView: View {
    
    @ObservedObject private var chatLogVM: ChatLogViewModel
//    @ObservedObject var chatLogVM: DetailedMessageViewModel
    @State private var MessageBarTextEditorPlaceholder: String = "Description"
    let chatUser: FriendEntity?
    
    init(chatUser: FriendEntity?) {
        self.chatUser = chatUser
        let firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper()
        self.chatLogVM = .init(firestoreService: firestoreService, chatUser: chatUser)
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
        .task {
            guard let unwrappedChatUser = self.chatUser else { return }
            chatLogVM.callFetchMessages(chatUser: unwrappedChatUser)
        }
    }
    
    private var bottomChatBarView: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
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
            }
            Button {
                Task {
                    guard let unwrappedChatUser = chatUser else { return }
                    await chatLogVM.callHandelSendMessage(chatUser: unwrappedChatUser)
                }
//                chatLogVM.handleSendMessage()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
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
    
    private var messagesView: some View {
        ScrollView {
            ForEach(chatLogVM.chatMessages, id: \.self) { message in
                VStack {
                    if message.fromId == chatLogVM.user.id {
                        HStack {
                            Spacer()
                            HStack {
                                Text(message.chatMessageText)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(.blue)
                            .cornerRadius(Constants.semiRoundedCornerRadius)
                        }
                    } else {
                        HStack {
                            
                            HStack {
                                Text(message.chatMessageText)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(Constants.semiRoundedCornerRadius)
                            Spacer()
                        }
                       
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

            }
            HStack {
                Spacer()
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

//struct ChatLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatLogView(chatUser: .constant(nil))
//    }
//}
