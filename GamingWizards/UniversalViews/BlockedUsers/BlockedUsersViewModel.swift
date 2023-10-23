//
//  BlockedUsersViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/4/23.
//

import Foundation
import SwiftUI
import Combine

@MainActor class BlockedUsersViewModel: ObservableObject {
    let coreDataController: CoreDataController
    private let firestoreService: FirebaseFirestoreService
    @Published var selectedUsedToUnblock: BlockedUserEntity?
    @Published var blockedUserEntities: [BlockedUserEntity] = []
    private var cancellable: AnyCancellable?
    
    init(
        coreDataController: CoreDataController = CoreDataController.shared,
        firestoreService: FirebaseFirestoreService = FirebaseFirestoreHelper.shared
    ) {
        self.coreDataController = coreDataController
        self.firestoreService = firestoreService
        self.cancellable = coreDataController.fetchBlockedUserEntitiesPublisher()
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { blockedUser in
                        self.blockedUserEntities = blockedUser
                    }
    }
    
    func removeBlockedUserAtIndex(index: Int) {
        
    }
    
    func callUnblockUser(blockedUser: BlockedUserEntity) async {
        do {
            try await firestoreService.deleteBlockedUser(blockedUser: blockedUser)
        } catch {
            print("call to unblock user failed")
            return
        }
        if let indexToRemove = blockedUserEntities.firstIndex(where: { $0.id == blockedUser.id }) {
            blockedUserEntities.remove(at: indexToRemove)
        }
    }
    
}
