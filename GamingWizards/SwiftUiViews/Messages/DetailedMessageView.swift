//
//  DetailedMessageView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/1/23.
//

import SwiftUI

struct DetailedMessageView: View {
    
    @ObservedObject var detailedMessageVM = DetailedMessageViewModel()
    @State private var MessageBarTextEditorPlaceholder: String = "Description"
    @State private var chatText: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                messagesView
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
                if self.chatText.isEmpty {
                    TextEditor(text: $MessageBarTextEditorPlaceholder)
                        .foregroundColor(.gray)
                        .disabled(true)
                        .frame(height: 50)
                }
                TextEditor(text: $chatText.max(Constants.textFieldMaxCharacters))
                    .opacity(chatText.isEmpty ? 0.25 : 1)
                    .frame(height: 50)
            }
            Button {
                detailedMessageVM.handleSendMessage(text: self.chatText)
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
//            ForEach(0..<20) { num in
            ForEach(detailedMessageVM.coreDataController.savedFriendEntities, id: \.self) { friend in
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

struct DetailedMessageView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedMessageView()
    }
}
