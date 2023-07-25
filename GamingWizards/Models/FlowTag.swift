//
//  GameTag.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/21/23.
//

import SwiftUI

class FlowTag: Identifiable, ObservableObject, Hashable {
    let id = UUID()
    @Published var textName: String
    @Published var textColor: Color = Color.black
    @Published var backgroundColor: Color = Color.lightGrey
    @Published var confirmationImage: Image = Image("circle")
    @Published var isSelected: Bool = false
//    @Published var colorTest: Color
    
    init(gameName: String) {
        self.textName = gameName
//        self.colorTest = colorTest
    }
    
    // Implement the hash(into:) function for Hashable conformance
    func hash(into hasher: inout Hasher) {
        // Combine the hash value using the properties that uniquely identify the GameItem
        hasher.combine(id)
        hasher.combine(textName)
    }
    
    // Implement the == operator for Hashable conformance
    static func == (lhs: FlowTag, rhs: FlowTag) -> Bool {
        // Check whether the GameItems have the same id and gameName
        return lhs.id == rhs.id && lhs.textName == rhs.textName
    }
    
}

