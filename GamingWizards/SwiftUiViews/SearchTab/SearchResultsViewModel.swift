//
//  SearchResultsViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/4/23.
//

import SwiftUI

//extension SearchResultsView {
     class SearchResultsViewModel: ObservableObject {
//        @Published var searchText: String = ""
         @ObservedObject var user = UserObservable.shared
         @Published var users: [User]? = []
         @Published var resultWasTapped: Bool = false
         @Published var selectedUser: User
         @Published var isCreateReportUserViewShowing: Bool = false
         let fbFirestoreHelper: FirebaseFirestoreHelper
         let coreDataController: CoreDataController
         
         init(
            fbFirestoreHelper: FirebaseFirestoreHelper = .shared,
            coreDataController: CoreDataController = .shared,
            selectedUser: User = User(id: "110k1")
        ) {
            self.fbFirestoreHelper = fbFirestoreHelper
            self.coreDataController = coreDataController
            self._selectedUser = Published(initialValue: selectedUser)
        }
         
         func convertUserToFriendDataBinding(displayName: String, friendUserID: String, profileImageString: String, isFavorite: Bool, isFriend: Bool) -> Binding<FriendEntity> {
             let friendEntity: FriendEntity = coreDataController.convertToFriendEntity2(
                 displayName: displayName,
                 friendUserID: friendUserID,
                 profileImageString: profileImageString,
                 isFavorite: isFavorite,
                 isFriend: isFriend
             )
             // Create a Binding for the FriendEntity
             let binding = Binding(get: {
                 friendEntity
             }, set: { newValue in
                 // Update properties of friendEntity when the binding is set
     //            friendEntity.friendCodeID = newValue.friendCodeID
                 friendEntity.id = newValue.id
                 friendEntity.displayName = newValue.displayName
                 friendEntity.isFriend = newValue.isFriend
                 friendEntity.isFavorite = newValue.isFavorite
                 friendEntity.imageString = newValue.imageString
             })
             return binding
         }
        
        func searchForMatchingUsers(gameName: String, isPayToPlay: Bool) async {
            Task {
                do {
                    let listOfUsers: [User]? = try await fbFirestoreHelper.fetchMatchingUsersSearch(gameName: gameName, isPayToPlay: isPayToPlay)
                    guard let safeListOfUsers = listOfUsers else { return }
                    for user in safeListOfUsers {
                        // Have a check if they are in your blocked user list here as well
                        if coreDataController.checkIfUserIsInFriendList(user: user) == false && user.id != self.user.id {
                            self.users?.append(user)
                        }
                    }
                } catch {
                    print("ERROR RETRIEVING MATCHING GAMES FROM SEARCH: \(error)")
                }
            }
        }
        
    }
//}
