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
        .navigationTitle("place holder") // should be whom so ever the user name in. binding
        .navigationBarTitleDisplayMode(.inline)
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
                    await chatLogVM.callHandelSendMessage()
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
//            ForEach(0..<20) { friend in
            ForEach(chatLogVM.coreDataController.savedFriendEntities, id: \.self) { friend in
                HStack {
                    Spacer()
                    HStack {
                        Text("place holder message")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(Constants.semiRoundedCornerRadius)
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
