//
//  AuthenticationViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/19/22.
//

import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import SwiftUI
import AuthenticationServices
import CryptoKit
import CoreData

@MainActor class AuthenticationViewModel: ObservableObject {
    
    @AppStorage("log_Status") var log_Status = false
    @AppStorage("user_Email") var user_Email: String?
    @AppStorage("first_Name") var first_Name: String?
    @AppStorage("last_Name") var last_Name: String?
    @AppStorage("user_Id") var user_Id: String?
    @AppStorage("display_Name") var display_Name: String?
    @AppStorage("user_Friend_Code_ID") var user_Friend_Code_ID: String?
    @AppStorage("log_status") var log_status: Bool = false
    @Published var currentNonce: String = ""
    @Published var signInState: SignInState = .signedOut
    @Published var isLoading: Bool = false
    @Published var signingIn: String = ""
    @Published var myFriendListData: [Friend] = []
    @ObservedObject var user = UserObservable()
    let coreDataController = CoreDataController.shared
    let firestoreDatabase = Firestore.firestore()
    private var listeningRegistration: ListenerRegistration?
    static var sharedAuthenticationVM = AuthenticationViewModel()
    
    private init() { }

    enum SignInState {
        case signedIn
        case signedOut
  }
    
    func saveUserInfoInDatabase(_ user: User) {
        let path = firestoreDatabase.collection(Constants.users).document(user.id)
        path.getDocument { document, err in
            if ((document?.exists) == true) {
                let id = document?.data()?["id"] as? String ?? "No ID"
                let displayName = document?.data()?["displayName"] as? String ?? "No Username"
                let email = document?.data()?["email"] as? String ?? "No email"
                let friendID = document?.data()?["friendCodeID"] as? String ?? "no friendCodeID"
                //location
                //image
                let currentUser: User = User(id: id, displayName: displayName, email: email, location: "location not yet implemented", profileImageUrl: "no image implemented yet", friendID: friendID)
                self.saveUserToUserDefaults(user: currentUser)
                self.signInSuccess()
            } else {
                path.setData(user.userDictionary)
//                path.collection("friendList").document(friend.friendCodeID).setData(friend.friendDictionary)
//                path.collection("friendRequestList").document(friendRequest.friendCodeID).setData(friend.friendDictionary)
                self.saveUserToUserDefaults(user: user)
                self.signInSuccess()
            }
        }
    }
    
    private func signInSuccess() {
        self.signInState = .signedIn
        self.isLoading = false
        self.log_Status = true
    }
    
    private func saveUserToUserDefaults(user newUser: User) { // remove later. i use coredata over user defaults currently
        display_Name = newUser.displayName
        user_Email = newUser.email ?? ""
        user_Friend_Code_ID = newUser.friendID
        user_Id = newUser.id
//        first_Name = newUser.firstName
//        last_Name = newUser.lastName
        
        self.signInState = .signedIn
        self.isLoading = false
        self.log_Status = true
        retrieveFriendsListener()
//        for friend in self.coreDataController.savedFriendEntities {
//            self.coreDataController.deleteFriend(friend: friend)
//        }
//        retrieveFriends(uid: userID) //{ friends in
//            for friend in friends {
//                self.coreDataController.addFriend(friendCodeID: friend.friendCodeID, friendDisplayName: friend.friendDisplayName, isFriend: friend.isFriend, isFavorite: friend.isFavorite)
//            }
//        }
//        user.location = newUser.location
//        user.profileImageUrl = newUser.profileImageUrl
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
    
    func createUserBaseData(id: String, firstName: String, lastName: String, displayName: String, email: String?, location: String, profileImageUrl: String, friendID: String, /*friendList: [Friend], friendRequests: [Friend],*/ games: [String], groupSize: String, age: String, about: String, availability: String, title: String, payToPlay: Bool) -> User {
        let newUser = User(id: id,
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
        return newUser
    }

    func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            var remainingLength = length
            
            while remainingLength > 0 {
                let randoms: [UInt8] = (0 ..< 16).map { _ in
                    var random: UInt8 = 0
                    let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                    if errorCode != errSecSuccess {
                        fatalError(
                            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                        )
                    }
                    return random
                }
                
                randoms.forEach { random in
                    if remainingLength == 0 {
                        return
                    }
                    
                    if random < charset.count {
                        result.append(charset[Int(random)])
                        remainingLength -= 1
                    }
                }
            }
            
            return result
        }
    
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

//    func startSignInWithAppleFlow() {
//      let nonce = randomNonceString()
//      currentNonce = nonce
//      let appleIDProvider = ASAuthorizationAppleIDProvider()
//      let request = appleIDProvider.createRequest()
//      request.requestedScopes = [.fullName, .email]
//      request.nonce = sha256(nonce)
//
//      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//      authorizationController.delegate = self
//      authorizationController.presentationContextProvider = self
//      authorizationController.performRequests()
//    }
    
    //out dated. remove
    func retrieveFriends(uid: String) { //, completion: @escaping ([Friend]) -> () // this was an escaping. now it isnt
        let path = firestoreDatabase.collection(Constants.users).document(uid).collection("friendList")
            path.addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print("ERROR RETRIEVING FRIENDS: \(error)")
                    return
                }
//                guard let documents = querySnapshot.data() else { return }
                guard let documents = querySnapshot?.documents else { return }
                //deletes all friends locally
                for friend in self.coreDataController.savedFriendEntities {
                    self.coreDataController.deleteFriendLocally(friend: friend)
                }
                for document in documents {
                    let friendCodeID = document.data()["friendCodeID"] as? String ?? "????"
                    let friendUserID = document.data()["friendUserID"] as? String ?? ""
                    let friendDisplayName = document.data()["friendDisplayName"] as? String ?? ""
                    let isFriend = document.data()["isFriend"] as? Bool ?? false
                    let isFavorite = document.data()["isFavorite"] as? Bool ?? false
                    self.coreDataController.addFriend(friendCodeID: friendCodeID, friendUserID: friendUserID, friendDisplayName: friendDisplayName, isFriend: isFriend, isFavorite: isFavorite)
//                    self.coreDataController.addFriend(friendCodeID: friendCodeID, friendDisplayName: displayName, isFriend: isFriend, isFavorite: isFavorite)
//                    self.friendList.append(Friend(friendCodeID: friendCodeID, friendDisplayName: displayName, isFriend: isFriend))
                }
//                DispatchQueue.main.async {
                    //remove all friends
                    
                    //add new friends
                    
//                    let sortedFriends = self.friendList.sorted { !$0.isFriend && $1.isFriend }
                    // add into core data
//                    completion(sortedFriends)
//                }
            }
    }
    
    func deleteFriendInFirestore(friend: FriendEntity, userID: String) { //later when you get help, move the deleting of you from their friend list to be the first action then from your own list, and then locally,
        guard let userFriendCodeID = user_Friend_Code_ID else { return }
        guard let friendUserID = friend.friendUserID else { return }
        guard let friendCodeID = friend.friendCodeID else { return }
        firestoreDatabase.collection(Constants.users).document(friendUserID).collection("friendList").document(userFriendCodeID)
            .delete() { err in
                if let error = err {
                    print("ERROR DELETING YOURSELF FROM YOUR FRIEND'S FRIEND LIST: \(error.localizedDescription)")
                } else {
                    self.firestoreDatabase.collection(Constants.users).document(userID).collection("friendList").document(friendCodeID).delete() { err in
                        if let error = err {
                            print("ERROR DELETING SPECIFIC FRIEND IN THEIR FIRESTORE CLOUD: \(error.localizedDescription)")
                        } else {
                            self.coreDataController.deleteFriendLocally(friend: friend)
                        }
                    }
                }
            }
    }
    
    func retrieveFriendsListener() {
        guard let userID = user_Id else { return }
        listeningRegistration = firestoreDatabase.collection(Constants.users).document(userID).collection("friendList")
            .addSnapshotListener({ snapshot, err in
                if let error = err {
                    print("ERROR GETTING FRIEND LIST DOCUMENTS: \(error.localizedDescription)")
                } else {
                    guard let querySnapshot = snapshot else {
                        print("ERROR FETCHING SNAPSHOT DATA: ")
                        return
                    }
                    
                    let documents = querySnapshot.documents
                    //deletes all friends locally
                    for friend in self.coreDataController.savedFriendEntities {
                        self.coreDataController.deleteFriendLocally(friend: friend)
                    }
                    for document in documents {
                        let friendCodeID = document.data()["friendCodeID"] as? String ?? "????"
                        let friendUserID = document.data()["friendUserID"] as? String ?? ""
                        let friendDisplayName = document.data()["friendDisplayName"] as? String ?? ""
                        let isFriend = document.data()["isFriend"] as? Bool ?? false
                        let isFavorite = document.data()["isFavorite"] as? Bool ?? false
                        self.coreDataController.addFriend(friendCodeID: friendCodeID, friendUserID: friendUserID, friendDisplayName: friendDisplayName, isFriend: isFriend, isFavorite: isFavorite)
                    }
                    //keep. use it so I can update the ui cleaner
//                    self.myFriendListData = querySnapshot.documents.compactMap({ document in
//                        try? document.data(as: Friend.self)
//                    })
                    
                }
            })
    }
    
    func stopListening() {
        listeningRegistration?.remove()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            signInState = .signedOut
            withAnimation(.easeInOut) {
                log_Status = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

