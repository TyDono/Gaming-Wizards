//
//  MainMessagesViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/31/23.
//

import Foundation
import UIKit
import SwiftUI

extension MainMessagesView {
    @MainActor class MainMessagesViewModel: ObservableObject {
        @ObservedObject var user = UserObservable.shared
        var diskSpace = DiskSpaceHandler()
        @Published var profileImage: UIImage?
        
        func retrieveProfileImageFromDisk() {
            profileImage = diskSpace.loadProfileImageFromDisk(imageString: user.profileImageString)
        }
        
    }
}
