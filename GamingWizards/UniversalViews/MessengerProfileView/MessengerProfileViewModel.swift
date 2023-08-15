//
//  MessengerProfileViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/14/23.
//

import Foundation
import SwiftUI

extension MessengerProfileView {
    @MainActor class MessengerProfileViewModel: ObservableObject {
        @ObservedObject var user = UserObservable.shared
        @Published var profileImage: UIImage?
        let diskSpaceHandler = DiskSpaceHandler()
        
        func callRetrieveProfileImageFromDisk(imageString: String) {
            self.profileImage = diskSpaceHandler.loadProfileImageFromDisk(imageString: imageString)
        }
        
    }
}
