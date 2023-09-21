//
//  UserReport.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/2/23.
//

import Foundation

struct UserReport: Codable, Identifiable {
    
    var id: String
    var reason: ReportReason
    var creatorId: String
    var chatId: String
    var dateSent: Date
    var userReportedId: String
    var userReportMessage: String
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "reason": reason,
            "creatorId": creatorId,
            "chatId:": chatId,
            "dateSent": dateSent,
            "userReportedId": userReportedId
        ]
    }
    
}
