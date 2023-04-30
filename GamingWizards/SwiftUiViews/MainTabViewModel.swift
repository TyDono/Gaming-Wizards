//
//  MainTabViewModel.swift
//  Foodiii
//
//  Created by Tyler Donohue on 1/9/23.
//

import Foundation
import SwiftUI

extension MainTabView {
    @MainActor class MainTabViewModel: ObservableObject {
        @EnvironmentObject var mainTabViewModel: MainTabViewModel
        
    }
}
