//
//  UserReport.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/2/23.
//

import Foundation

struct UserReport: Codable {
    
    var reason: String
    var creatorId: String
    var chatId: String
    var dateSent: String
    var reportId: String
    var userReportedId: String
    
    var dictionary: [String: Any] {
        return [
            "reason": reason,
            "creatorId": creatorId,
            "chatId:": chatId,
            "dateSent": dateSent,
            "reportId": reportId,
            "userReportedId": userReportedId
        ]
    }
}
