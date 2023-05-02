//
//  UserSearchViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/1/23.
//

import Combine
import SwiftUI
import Foundation

extension UserSearchView {
    @MainActor class UserSearchViewModel: ObservableObject {
        @Published var messages = [Message]()
        @Published var searchText = ""
        @Published var searchScope = SearchScope.inbox
        
        var filteredMessages: [Message] {
            if self.searchText.isEmpty {
                return self.messages
            } else {
                return self.messages.filter { $0.text.localizedCaseInsensitiveContains(self.searchText) }
            }
        }
        
        func runSearch() {
            Task {
                guard let url = URL(string: "https://hws.dev/\(self.searchScope.rawValue).json") else { return }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                self.messages = try JSONDecoder().decode([Message].self, from: data)
            }
        }
        
    }
}
