//
//  SignInContentViewViewModel.swift
//  Foodiii
//
//  Created by Tyler Donohue on 9/13/22.
//

import Foundation
import SwiftUI

extension SignInView {
    @MainActor class SignInViewModel: ObservableObject {
        @AppStorage("log_Status") var log_Status = false
        
        func testrest() {
            if log_Status {
                
            } else {
            }
            
        }
        
    }
}
