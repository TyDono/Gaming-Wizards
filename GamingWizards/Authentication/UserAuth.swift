//
//  UserAuth.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/8/22.
//

import Combine

class UserAuth: ObservableObject {
    @Published var isLoggedIn: Bool = false
    func logIn() {
        self.isLoggedIn = true
    }
}
