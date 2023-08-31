//
//  MessageView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/31/23.
//

import SwiftUI

struct MessageView: View {
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseAuthHelper.shared.auth.currentUser?.uid {
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
        .padding(.top, 4)
    }
    
}
