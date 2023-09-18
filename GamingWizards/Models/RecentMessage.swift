//
//  RecentMessage.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/6/23.
//

import Foundation
import Firebase

struct RecentMessage: Identifiable, Hashable, Codable {
    var id: String { documentId }
    var documentId: String
    var text: String
    var fromId: String
    var toId: String
    var chatUserDisplayName: String
    var timeStamp: Timestamp
    var imageString: String
    var onlineStatus: Bool
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data[Constants.chatMessageText] as? String ?? ""
        self.fromId = data[Constants.fromId] as? String ?? ""
        self.toId = data[Constants.toId] as? String ?? ""
        self.chatUserDisplayName = data[Constants.displayName] as? String ?? ""
        self.timeStamp = data[Constants.chatMessageTimeStamp] as? Timestamp ?? Timestamp(date: Date())
        self.imageString = data[Constants.imageString] as? String ?? ""
        self.onlineStatus = data[Constants.onlineStatus] as? Bool ?? false
        
    }
}
