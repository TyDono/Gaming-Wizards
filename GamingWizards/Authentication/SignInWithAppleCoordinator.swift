//
//  SignInWithAppleCoordinator.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


class SignInWithAppleCoordinator: NSObject, ASAuthorizationControllerPresentationContextProviding, ObservableObject {

//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
//    @State private var authenticationViewModel = AuthenticationViewModel()
//    let session: SessionStore
    let scenes = UIApplication.shared.connectedScenes

    @ObservedObject var user = UserObservable()


//    init(session: SessionStore) {
//        self.session = session
//    }

    //not used
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window!
//        if #available(iOS 15, *) {
//            return UIWindowScene.windows.first!
//        } else {
//            return windowScene
//            return UIApplication.shared.windows.first!
//        }
    }

    // Unhashed nonce.
    fileprivate var currentNonce: String?

    func startSignInWithAppleFlow() {
        let nonce = authenticationViewModel.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

@available(iOS 13.0, *)
extension SignInWithAppleCoordinator: ASAuthorizationControllerDelegate {

    //note used
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            guard let nonce = currentNonce else {
//                fatalError("Invalid state: A login callback was received, but no login request was sent.")
//            }
//            guard let appleIDToken = appleIDCredential.identityToken else {
//                print("Unable to fetch identity token")
//                return
//            }
//            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                return
//            }
//            // Initialize a Firebase credential.
//            let credential = OAuthProvider.credential(withProviderID: "apple.com",
//                                                      idToken: idTokenString,
//                                                      rawNonce: nonce)
//
//            let firstName = appleIDCredential.fullName?.givenName ?? ""
//            let lastName = appleIDCredential.fullName?.familyName ?? ""
//            let email = appleIDCredential.email ?? ""
//
//            self.signInWithCredential(credential: credential) { [self] result, error in
//                if let error = error {
//                    //create an alert here
////                    session.alertItem = AlertItem(title: Text("Error Signing In With Apple"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
//                    return
//                }
//
//                guard let user = result else { return }
//                let id = user.user.uid
//                let firstName = ""
//                let lastName = ""
//                let displayName = user.user.displayName ?? ""
//                let email = user.user.email ?? "No email given"
//                let location = ""
//                let profileImageUrl = ""
//                let friendCodeID = String((UUID().uuidString.suffix(4))) // made so the collection can be made and users can just freely add and remove friends and friend requests
//                let newUser = authenticationViewModel.createUserBaseData(id: id, firstName: firstName, lastName: lastName, displayName: displayName, email: email, location: location, profileImageUrl: profileImageUrl, friendCodeID: friendCodeID)
////                    let user = User(id: id, firstName: firstName, lastName: lastName, email: email)
//                authenticationViewModel.saveUserInfoInDatabase(newUser)
////                    handleAddingUserToDatabase(user) //using authentication instead
//            }
//        }
//    }

    //not used
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        session.alertItem = AlertItem(title: Text("Error Signing In With Apple"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
//    }

    //not used
//    private func saveUserInfoInDatabase(_ user: User) {
//        let path = Firestore.firestore().collection("users").document(user.id)
//
//        do {
////            try path.setData(from: user)
//            saveUserToUserDefaults(user: user)
//        } catch let error {
//            session.alertItem = AlertItem(title: Text("Error Saving Data"), message: Text("\(error.localizedDescription)"), dismissButton: .default(Text("OK")))
//        }
//    }

    private func saveUserToUserDefaults(user newUser: User) {
//        user.id = newUser.id
//        user.firstName = newUser.firstName
//        user.lastName = newUser.lastName
//        user.email = newUser.email
//        user.location = newUser.location
//        user.profileImageUrl = newUser.profileImageUrl
    }

    func notificationSignup() {
        //this need app delegate to work i have disabled it for now
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//        let imageURLString = ""
//        let message: String = AppDelegate.GamingWizardsUserSignupNotificationGreeting
//        let notification = GamingWizardsNotification(type: .foodiNotification,
//                                          imageUrl: imageURLString,
//                                          message: message,
//                                          datePosted: Date().dateToUTC,
//                                          intelId: "edit_user_profile")
//        let notificationPath: DocumentReference
//        notificationPath = Firestore.firestore().collection("users").document(userId).collection("notifications").document(notification.id)
//        let values: [String: Any] = [
//            "id": notification.id,
//            "type": notification.type.rawValue,
////            "image_url": notification.imageUrl,
//            "message": notification.message,
//            "is_read": notification.isRead
//        ]
//        notificationPath.setData(values)
    }
    
    func appleAuthenticate(credential: ASAuthorizationAppleIDCredential) {
        guard let token = credential.identityToken else {
            print("ERROR WITH FIREBASE")
            return
        }
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("ERROR WITH APPLE TOKEN")
            return
        }
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: self.authenticationViewModel.currentNonce)
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err {
                print("APPLE AUTHENTICATION ERROR: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            
            let id: String = user.uid
            let firstName = ""
            let lastName = ""
            let displayName = user.displayName ?? ""
            let email = user.email ?? "No email given "
            let location = ""
            let profileImageUrl = ""
            let friendID = String((UUID().uuidString.suffix(4)))
//            let friendList = [Friend]
//            let friendRequests = [Friend]
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
                                                                          profileImageUrl: profileImageUrl,
                                                                          friendID: friendID,
                                              //                            friendList: friendList,
                                              //                            friendRequests: friendRequests,
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
