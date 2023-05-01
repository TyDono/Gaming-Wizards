//
//  Message.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 1/11/23.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: Int
    var user: String
    var text: String
}

enum SearchScope: String, CaseIterable {
    case inbox,
         favorites
}
