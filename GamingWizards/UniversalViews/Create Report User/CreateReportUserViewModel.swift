//
//  CreateReportUserViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/19/23.
//

import Foundation
import SwiftUI

extension CreateReportUserView {
    class CreateReportUserViewModel: ObservableObject {
        @ObservedObject var user: UserObservable
        private let firestoreService: FirebaseFirestoreService
        @Published var userReportDescription: String = ""
        
        init(userObservable: UserObservable = UserObservable.shared,
             firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper.shared)
        {
            self.user = userObservable
            self.firestoreService = firestoreService
        }
        
        func handleSendUserReportWasTapped(userReport: UserReport) async {
            do {
                try await firestoreService.saveUserReportToFirestore(userReport: userReport)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func constructUserReportBaseData(reportReason: ReportReason, reporterId: String, reportedUserId: String, userReportedMessage: String, chatRoomId: String?) -> UserReport {
            let currentTimeAndDate = AppContext.getDateAndTimeWhenCreated()
            let reportId = UUID().uuidString
            let userReport = UserReport(id: reportId,
                                        reason: reportReason,
                                        creatorId: reporterId,
                                        chatId: chatRoomId ?? "No Chat Room",
                                        dateSent: currentTimeAndDate,
                                        userReportedId: reportedUserId,
                                        userReportMessage: userReportedMessage)
            return userReport
        }
        
    }
}
