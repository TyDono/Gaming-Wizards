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
import Security

@MainActor class AuthenticationViewModel: ObservableObject {
    
    @AppStorage(Constants.appStorageStringLogStatus) var log_Status = false
    
//    @AppStorage(Constants.appStorageStringUserEmail) var user_Email: String?
//    @AppStorage(Constants.appStorageStringUserFirstName) var first_Name: String?
//    @AppStorage(Constants.appStorageStringUserLastName) var last_Name: String?
//    @AppStorage(Constants.appStorageStringUserId) var user_Id: String?
//    @AppStorage(Constants.appStorageStringUserDisplayName) var display_Name: String?
//    @AppStorage(Constants.appStorageStringUserFriendCodeID) var user_Friend_Code_ID: String?
//    @AppStorage(Constants.appStorageStringUserProfileImageString) var profile_Image_String: String?
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
//    private let keychainHelper = KeychainHelper()
    
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
                let currentUser: User = User(id: id, displayName: displayName, email: email, location: "location not yet implemented", profileImageString: "no image implemented yet", friendCodeID: friendID)
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
    
    private func saveUserToUserDefaults(user newUser: User) {
//        user.id = newUser.id
        KeychainHelper.saveUserID(userID: user.id)
        user.firstName = newUser.firstName
        user.lastName = newUser.lastName
        user.displayName = newUser.displayName
        user.email = newUser.email ?? ""
        user.location = newUser.location
        user.profileImageString = newUser.profileImageString
        user.friendCodeID = newUser.friendCodeID
        user.listOfGames = newUser.listOfGames
        user.groupSize = newUser.groupSize
        user.age = newUser.age
        user.about = newUser.about
        user.availability = newUser.availability
        user.title = newUser.title
        user.isPayToPlay = newUser.isPayToPlay
        user.isSolo = newUser.isSolo
        /*
         case id = "user_id"
         case firstName = "first_name"
         case lastName = "last_name"
         case displayName = "display_Name"
         case email = "user_email"
         case location = "user_location"
         case profileImageString = "profile_image_string"
         case friendID = "friendCodeID"
         case friendList = "friendList"
         case friendRequests = "friendRequests"
         case listOfGames = "listOfGames"
         case groupSize = "groupSize"
         case age = "age"
         case about = "about"
         case availability = "availability"
         case title = "title"
         case payToPlay = "isPayToPlay"
         case isSolo = "isSolo"
         */
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
    
    func createUserBaseData(id: String, firstName: String, lastName: String, displayName: String, email: String?/*friendList: [Friend], friendRequests: [Friend],*/) -> User { // SHOULD ONLY BE CALLED ONCE EVER!!!
        let location = ""
        let profileImageString = "\(UUID().uuidString).jpg"
        let friendID = String((UUID().uuidString.suffix(4)))
        let games: [String] = []
        let groupSize = ""
        let age = 0
        let about = ""
        let availability = ""
        let title = ""
        let isSolo = true
        let payToPlay = false
        user.profileImageString = profileImageString
        let newUser = User(id: id,
                           firstName: firstName,
                           lastName: lastName,
                           displayName: displayName,
                           email: email,
                           location: location,
                           profileImageString: profileImageString,
                           friendCodeID: friendID,
//                            friendList: friendList,
//                            friendRequests: friendRequests,
                           listOfGames: games,
                           groupSize: groupSize,
                           age: age,
                           about: about,
                           availability: availability,
                           title: title,
                           isPayToPlay: payToPlay,
                           isSolo: isSolo)
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
                    let friendCodeID = document.data()[Constants.friendCodeID] as? String ?? "????"
                    let friendUserID = document.data()[Constants.friendUserID] as? String ?? ""
                    let friendDisplayName = document.data()[Constants.friendDisplayName] as? String ?? ""
                    let isFriend = document.data()[Constants.isFriend] as? Bool ?? false
                    let isFavorite = document.data()[Constants.isFavorite] as? Bool ?? false
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
        guard let userFriendCodeID = user.friendCodeID else { return }
        guard let friendUserID = friend.friendUserID else { return }
        guard let friendCodeID = friend.friendCodeID else { return }
        firestoreDatabase.collection(Constants.users).document(friendUserID).collection(Constants.userFriendList).document(userFriendCodeID)
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
         let userID = user.id //else { return }
        listeningRegistration = firestoreDatabase.collection(Constants.users).document(userID).collection(Constants.userFriendList)
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
                        let friendCodeID = document.data()[Constants.friendCodeID] as? String ?? "????"
                        let friendUserID = document.data()[Constants.friendUserID] as? String ?? ""
                        let friendDisplayName = document.data()[Constants.friendDisplayName] as? String ?? ""
                        let isFriend = document.data()[Constants.isFriend] as? Bool ?? false
                        let isFavorite = document.data()[Constants.isFavorite] as? Bool ?? false
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

