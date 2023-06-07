//
//  SignInWithGoogleCoordinator.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 1/11/23.
//

import Foundation
import Firebase
import FirebaseCore
import GoogleSignIn
import SwiftUI
import AuthenticationServices
import CryptoKit
import CoreData

@MainActor class SignInWithGoogleCoordinator: ObservableObject {
    
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
//    @State private var authenticationViewModel = AuthenticationViewModel()
    let scenes = UIApplication.shared.connectedScenes
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let configuration = GIDConfiguration(clientID: clientID)
        self.authenticationViewModel.isLoading = true //error when ran:::
        //Fatal error: No ObservableObject of type AuthenticationViewModel found. A View.environmentObject(_:) for AuthenticationViewModel may be missing as an ancestor of this view.
        //withPresenting: self) { [unowned self]
        GIDSignIn.sharedInstance.signIn(withPresenting: self.authenticationViewModel.getRootViewController()) { [unowned self] result, err in
            if let error = err {
                self.authenticationViewModel.isLoading = false
                print("FIREBASE ERROR: \(error.localizedDescription)")
                return
            }
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                self.authenticationViewModel.isLoading = false
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, err in
                if let error = err {
                    print("FIREBASE AUTH ERROR: \(error.localizedDescription)")
                    return
                }
                guard let user = result?.user else { return }
                let id: String = user.uid
                let firstName = ""
                let lastName = ""
                let displayName = user.displayName ?? ""
                let email = user.email ?? "No email given "
                let location = ""
                let profileImageString = ""
                let friendID = String((UUID().uuidString.suffix(4)))
//                let friendList = [Friend]
//                let friendRequests = [Friend]
                let games: [String] = []
                let groupSize = ""
                let age = ""
                let about = ""
                let availability = ""
                let title = ""
                let payToPlay = false
                
                let newUser = self.authenticationViewModel.createUserBaseData(id: id,
                                                                              firstName: firstName,
                                                                              lastName: lastName,
                                                                              displayName: displayName,
                                                                              email: email,
                                                                              location: location,
                                                                              profileImageString: profileImageString,
                                                                              friendID: friendID,
//                                                                              friendList: friendList,
//                                                                              friendRequests: friendRequests,
                                                                              games: games,
                                                                              groupSize: groupSize,
                                                                              age: age,
                                                                              about: about,
                                                                              availability: availability,
                                                                              title: title,
                                                                              payToPlay: payToPlay)
                self.authenticationViewModel.saveUserInfoInDatabase(newUser)
            }
        }
    }
    
}
