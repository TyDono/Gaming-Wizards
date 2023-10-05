//
//  BlockedUsersViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/4/23.
//

import Foundation
import SwiftUI

class BlockedUsersViewModel: ObservableObject {
    let coreDataController: CoreDataController
    private let firestoreService: FirebaseFirestoreService
    
    init(
        coreDataController: CoreDataController = CoreDataController.shared,
        firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper.shared
    ) {
        self.coreDataController = coreDataController
        self.firestoreService = firestoreService
    }
    
    func callUnblockUser(blockedUser: BlockedUserEntity) async {
        do {
            try await firestoreService.deleteBlockedUser(blockedUser: blockedUser)
        } catch {
            
        }
    }
    
}
