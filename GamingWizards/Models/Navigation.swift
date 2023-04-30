//
//  Navigation.swift
//  Foodiii
//
//  Created by Tyler Donohue on 9/28/22.
//

import Foundation
import SwiftUI

class Navigation {
    
    enum foodiiiViews { // alphabetize
        case settingsView
        
        case homeView
        case navigationLogInView
    }
    
//    func getView(view: foodiiiViews) -> some View {
//        switch view { // make exhaustive
//        case .settingsView:
//            return AnyView(ChoiceOneView(view: SettingsView()))
////            return SettingsView()
//        default:
//            return  NavigationLogInView()
//        }
//    }
    
//    @ViewBuilder func getView(view: String) -> some View {
//        switch view {
//        case "CreateUser":
//            Text(view)
//        case "Abc":
//            Image("Abc")
//        default:
//            EmptyView()
//        }
//    }
}
