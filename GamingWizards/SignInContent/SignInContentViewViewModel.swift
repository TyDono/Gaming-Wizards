//
//  SignInContentViewViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/13/22.
//

import SwiftUI

extension SignInView {
    @MainActor class SignInViewModel: ObservableObject {
        @AppStorage(Constants.appStorageStringLogStatus) var log_Status = false
        
        func testrest() {
            if log_Status {
                
            } else {
            }
            
        }
        
    }
}
