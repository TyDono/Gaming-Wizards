//
//  ViewPersonalAccountViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

extension ViewPersonalAccountView {
    class ViewPersonalAccountViewModel: ObservableObject {
        @ObservedObject var user: UserObservable
        var diskSpace: DiskSpaceHandler
        @Published var profileImage: UIImage?
        @Published var isShowingEditAccountView: Bool = false
        /*
         init(
             friendListVM: FriendListViewModel = .init(),
             authenticationViewModel: AuthenticationViewModel = .sharedAuthenticationVM,
             coreDataController: CoreDataController = .shared,
             fbFirestoreHelper: FirebaseFirestoreHelper = .shared
         ) {
             self.friendListVM = friendListVM
             self.authenticationViewModel = authenticationViewModel
             self.coreDataController = coreDataController
             self.fbFirestoreHelper = fbFirestoreHelper
           }
         */
        
        init(
            user: UserObservable,
            diskSpace: DiskSpaceHandler = DiskSpaceHandler()
            
        ) {
            self.user = user
            self.diskSpace = diskSpace
        }
        
        func retrieveProfileImageFromDisk() {
            profileImage = diskSpace.loadProfileImageFromDisk(imageString: user.profileImageString)
        }
        
    }
}
