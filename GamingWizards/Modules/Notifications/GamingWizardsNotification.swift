//
//  FoodiNotification.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/11/22.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct GamingWizardsNotification: Identifiable, Equatable {
    var id: String? = UUID().uuidString
    let type: NotificationType
    let imageUrl: String
    let message: String
    let datePosted: String
    let intelId: String
    var isRead = false
    
    static func ==(lhs: GamingWizardsNotification, rhs: GamingWizardsNotification) -> Bool {
        return lhs.id == rhs.id
    }
}

enum NotificationType: String {
    case comments = "comments"
    case gamingWizardNotification = "gamingWizardNotification"
}

final class NotificationViewModel: ObservableObject {
    @Published var selectedNotification: GamingWizardsNotification?
}
