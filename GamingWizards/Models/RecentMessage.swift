//
//  RecentMessage.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/6/23.
//

import Foundation
import Firebase

struct RecentMessage: Identifiable, Hashable {
    var id: String { documentId }
    let documentId: String
    let text: String
    let fromId: String
    let toId: String
    let chatUserDisplayName: String
    let timeStamp: Timestamp
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data[Constants.chatMessageText] as? String ?? ""
        self.fromId = data[Constants.fromId] as? String ?? ""
        self.toId = data[Constants.toId] as? String ?? ""
        self.chatUserDisplayName = data[Constants.displayName] as? String ?? ""
        self.timeStamp = data[Constants.chatMessageTimeStamp] as? Timestamp ?? Timestamp(date: Date())
        
    }
}
