//
//  ManageListOfGamesView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/18/23.
//

import Foundation
import SwiftUI

struct ManageListOfGamesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var manageListOfGamesVM = ManageListOfGamesViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text("this is text here")
            }
        }
    }
    
}
