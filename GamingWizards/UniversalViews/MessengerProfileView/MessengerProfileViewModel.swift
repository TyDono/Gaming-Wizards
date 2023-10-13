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
        @ObservedObject var user: UserObservable
        @Published var profileImage: UIImage?
        @Published var profileImageString: String
        let diskSpaceHandler: DiskSpaceHandler
        private var imageCache: [String: UIImage] = [:]
        
        init(userObservable: UserObservable = UserObservable.shared,
             diskSpaceHandler: DiskSpaceHandler = DiskSpaceHandler(),
             profileImageString: String)
        {
            self.user = userObservable
            self.diskSpaceHandler = diskSpaceHandler
            self.profileImageString = profileImageString
            
            self.profileImage = loadImageFromDisk(imageString: profileImageString)
        }
        
        func loadImageFromDisk(imageString: String) -> UIImage? {
            if let cachedImage = imageCache[imageString] {
                return cachedImage
            } else {
                if let image = diskSpaceHandler.loadProfileImageFromDisk(imageString: imageString) {
                    imageCache[imageString] = image
                    return image
                }
            }
            return nil
        }
        
    }
}
