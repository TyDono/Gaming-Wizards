//
//  ChatMessage.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/21/23.
//

import Foundation

struct ChatMessage: Hashable, Identifiable {
    var id: String { documentId }
    
    let documentId: String
    let fromId: String
    let toId: String
    let chatMessageText: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[Constants.fromId] as? String ?? ""
        self.toId = data[Constants.toId] as? String ?? ""
        self.chatMessageText = data[Constants.chatMessageText] as? String ?? ""
    }
}
