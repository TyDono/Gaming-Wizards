//
//  SearchResultsDetailViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/18/23.
//

import Foundation
import FirebaseFirestore

@MainActor class SearchResultsDetailViewModel: ObservableObject {
    @Published var users: [User] = []
    let firesStoreDatabase = Firestore.firestore()
    
}
