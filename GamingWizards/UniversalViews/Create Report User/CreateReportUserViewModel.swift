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
        
    }
}
