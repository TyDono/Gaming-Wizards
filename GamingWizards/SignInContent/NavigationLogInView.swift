//
//  LoadingAppLogInView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/8/22.
//

import SwiftUI
import Firebase
import SwiftUI
import GoogleSignIn

struct NavigationLogInView: View {
    
    @AppStorage("log_Status") var log_Status = false
    
    var body: some View {
        if log_Status {
            MainTabView()
        } else {
            SignInView()
        }
    }
}
