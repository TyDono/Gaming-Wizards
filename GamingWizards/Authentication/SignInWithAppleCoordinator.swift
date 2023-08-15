//
//  SignInWithAppleCoordinator.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/7/22.
//

import AuthenticationServices
import CryptoKit
import FirebaseAnalytics
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


class SignInWithAppleCoordinator: NSObject, ASAuthorizationControllerPresentationContextProviding, ObservableObject {
     private var authenticationViewModel = AuthenticationViewModel.sharedAuthenticationVM
//    let session: SessionStore
    let scenes = UIApplication.shared.connectedScenes
    // Unhashed nonce.
    fileprivate var currentNonce: String?

//    init(session: SessionStore) {
//        self.session = session
//    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window!
    }

    @MainActor func startSignInWithAppleFlow() {
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
    
    @MainActor func appleAuthenticate(credential: ASAuthorizationAppleIDCredential) {
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
            let newUser = self.authenticationViewModel.createUserBaseData(id: id,
                                                                          firstName: firstName,
                                                                          lastName: lastName,
                                                                          displayName: displayName,
                                                                          email: email
                                                                         )
            self.authenticationViewModel.saveUserIntoFirestore(for: newUser)
        }
    }

}
