//
//  AlertItem.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    var id: String? = UUID().uuidString
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
    var actionButton: Alert.Button? = nil
}
