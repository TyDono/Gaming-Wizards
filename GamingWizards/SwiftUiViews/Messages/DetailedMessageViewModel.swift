//
//  DetailedMessageViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 8/1/23.
//

import Foundation
import SwiftUI

extension DetailedMessageView {
    @MainActor class DetailedMessageViewModel: ObservableObject {
        @Published var user = UserObservable.shared
        @Published var coreDataController = CoreDataController.shared
//        @Published var chatText: String = ""
        
        init() {
            
        }
        
        func handleSendMessage(text: String) {
            print(text)
        }
        
    }
}