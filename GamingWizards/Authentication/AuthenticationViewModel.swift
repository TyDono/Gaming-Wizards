//
//  AuthenticationViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/19/22.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import GoogleSignIn
import SwiftUI
import AuthenticationServices
import CryptoKit
import CoreData
import Security
import FirebaseStorage
//import FirebaseFirestoreSwift

@MainActor class AuthenticationViewModel: ObservableObject {
    
    @AppStorage(Constants.appStorageStringLogStatus) var log_Status = false
    @ObservedObject var user = UserObservable.shared
    var diskSpace = DiskSpace()
    @Published var currentNonce: String = ""
    @Published var signInState: SignInState = .signedOut
    @Published var isLoading: Bool = false
    @Published var signingIn: String = ""
    @Published var myFriendListData: [Friend] = []
//    @Published var user = UserObservable.shared
    let coreDataController = CoreDataController.shared
    let firestoreDatabase = Firestore.firestore()
    private var listeningRegistration: ListenerRegistration?
    static var sharedAuthenticationVM = AuthenticationViewModel()
    let storageRef = Storage.storage()
//    private let keychainHelper = KeychainHelper()
    
    private init() { }

    enum SignInState {
        case signedIn
        case signedOut
  }
    
    func saveUserIntoFirestore(for user: User) {
        let documentPath = firestoreDatabase.collection(Constants.users).document(user.id)
        documentPath.getDocument { [weak self] document, err in
            if let error = err {
                print("ERROR RETRIEVING FIRESTORE USER DATA WHEN TRYING TO SIGN IN: \(error.localizedDescription)")
                return
            }
            
            if document?.exists == true {
                if let documentData = document?.data() {
                    if let existingUser = try? Firestore.Decoder().decode(User.self, from: documentData) {
                        self?.retrieveUserProfileImage(imageString: existingUser.profileImageString) { profileImage in
                            if let image = profileImage {
                                self?.diskSpace.saveProfileImageToDisc(imageString: existingUser.profileImageString, image: image)
                            }
                        }
                        self?.saveUserToUserDefaults(user: existingUser)
                        // add image from storage here. get the image from cloud storage using document.profileImageString. then save the image to disk
                    }
                }
            } else {
                documentPath.setData(user.userDictionary)
                self?.saveUserToUserDefaults(user: user)
            }
        }
    }

    
    func saveUserInfoInDatabase(_ user: User) async { //NOT USED
        let path = firestoreDatabase.collection(Constants.users).document(user.id)
        
        do {
            let snapshot = try await path.getDocument()

            if snapshot.exists {
                // User exists
                let document = try snapshot.data(as: User.self)

                self.saveUserToUserDefaults(user: document)
                self.signInSuccess()
            } else {
                // User doesn't exist
                try await path.setData(user.userDictionary)
                self.saveUserToUserDefaults(user: user)
                self.signInSuccess()
            }
        } catch {
            print("ERROR RETRIEVING FIRESTORE USER DATA: \(error.localizedDescription)")
            return
        }
        
//        path.getDocument { document, err in
//            if ((document?.exists) == true) {
//                let userInfo = try document?.data(as: User.self)
                // EXISTING USER
//                let data = document?.data()
//                let id = data?[Constants.userID] as? String ?? ""
//                let displayName = data[Constants.userDisplayName] as? String ?? ""
//                let email = data[Constants.userEmail] as? String ?? ""
//                let location = data[""] as? String ?? ""
//                let profileImageString = data[Constants.userProfileImageString] as? String ?? ""
//                let friendCodeID = data[Constants.userFriendID] as? String ?? ""
//                let friendList = document.data()[Constants.userFriendList] as? [Friend]
//                let listOfGames = data[Constants.userListOfGamesString] as? [String] ?? [""]
//                let groupSize = data[Constants.userGroupSize] as? String ?? ""
//                let age = data[Constants.userAge] as? String ?? ""
//                let about = data[Constants.userAbout] as? String ?? ""
//                let availability = data[Constants.userAvailability] as? String ?? ""
//                let title = data[Constants.userTitle] as? String ?? ""
//                let isPayToPlay = data[Constants.userPayToPlay] as? Bool ?? false
//                let isSolo = data[Constants.userIsSolo] as? Bool ?? true
//                let currentUser = User(id: id, /*firstName: <#T##String#>, lastName: <#T##String#>,*/ displayName: displayName, email: email, location: location, profileImageString: profileImageString, friendCodeID: friendCodeID, friendList: friendList, /*friendRequests: <#T##[Friend]#>,*/ listOfGames: listOfGames, groupSize: groupSize, age: age, about: about, availability: availability, title: title, isPayToPlay: isPayToPlay, isSolo: isSolo)
//                let currentUser: User = User(id: id, displayName: displayName, email: email, location: "", profileImageString: "", friendCodeID: friendID)
//                self.saveUserToUserDefaults(user: userInfo)
//                self.signInSuccess()
//            } else {
                // NEW USER
//                path.setData(user.userDictionary)
//                path.collection("friendList").document(friend.friendCodeID).setData(friend.friendDictionary)
//                path.collection("friendRequestList").document(friendRequest.friendCodeID).setData(friend.friendDictionary)
//                self.saveUserToUserDefaults(user: user)
//                self.signInSuccess()
//            }
//
//        }
    }
    
    private func retrieveUserProfileImage(imageString: String, completion: @escaping (UIImage?) -> Void) {
        let storagePath = storageRef.reference().child("profileImages/\(imageString)")
        storagePath.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("ERROR DOWNLOADING PERSONAL USER PROFILE IMAGE FROM FIREBASE STORAGE: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                completion(image)
            } else {
                print("Failed to convert image data to UIImage")
                completion(nil)
                return
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
        KeychainHelper.saveUserID(userID: newUser.id)
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
        retrieveFriendsListener()
        self.signInSuccess()
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
    
    func createUserBaseData(id: String, firstName: String, lastName: String,displayName: String, email: String?/*friendList: [Friend], friendRequests: [Friend],*/) -> User {
        let displayName = ""
        let location = ""
        let profileImageString = "\(UUID().uuidString).jpg"
        let friendID = String((UUID().uuidString.suffix(4)))
        let games: [String] = []
        let groupSize = ""
        let age = ""
        let about = ""
        let availability = ""
        let title = ""
        let isSolo = true
        let payToPlay = false
//        user.profileImageString = profileImageString
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
            path.addSnapshotListener { [weak self] querySnapshot, err in
                if let error = err {
                    print("ERROR RETRIEVING FRIENDS: \(error)")
                    return
                }
//                guard let documents = querySnapshot.data() else { return }
                guard let documents = querySnapshot?.documents else { return }
                //deletes all friends locally
                guard let savedFriendEntities = self?.coreDataController.savedFriendEntities else { return }
                for friend in savedFriendEntities {
                    self?.coreDataController.deleteFriendLocally(friend: friend)
                }
                for document in documents {
                    let friendCodeID = document.data()[Constants.friendCodeID] as? String ?? "????"
                    let friendUserID = document.data()[Constants.friendUserID] as? String ?? ""
                    let friendDisplayName = document.data()[Constants.friendDisplayName] as? String ?? ""
                    let isFriend = document.data()[Constants.isFriend] as? Bool ?? false
                    let isFavorite = document.data()[Constants.isFavorite] as? Bool ?? false
                    self?.coreDataController.addFriend(friendCodeID: friendCodeID, friendUserID: friendUserID, friendDisplayName: friendDisplayName, isFriend: isFriend, isFavorite: isFavorite)
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
//        guard let userFriendCodeID = user.friendCodeID else { return }
        guard let friendUserID = friend.friendUserID else { return }
        guard let friendCodeID = friend.friendCodeID else { return }
        firestoreDatabase.collection(Constants.users).document(friendUserID).collection(Constants.userFriendList).document(user.friendCodeID)
            .delete() { [weak self] err in
                if let error = err {
                    print("ERROR DELETING YOURSELF FROM YOUR FRIEND'S FRIEND LIST: \(error.localizedDescription)")
                } else {
                    self?.firestoreDatabase.collection(Constants.users).document(userID).collection("friendList").document(friendCodeID).delete() { [weak self] err in
                        if let error = err {
                            print("ERROR DELETING SPECIFIC FRIEND IN THEIR FIRESTORE CLOUD: \(error.localizedDescription)")
                        } else {
                            self?.coreDataController.deleteFriendLocally(friend: friend)
                        }
                    }
                }
            }
    }
    
    func retrieveFriendsListener() {
         let userID = user.id //else { return }
        listeningRegistration = firestoreDatabase.collection(Constants.users).document(userID).collection(Constants.userFriendList)
            .addSnapshotListener({ [weak self] snapshot, err in
                if let error = err {
                    print("ERROR GETTING FRIEND LIST DOCUMENTS: \(error.localizedDescription)")
                } else {
                    guard let querySnapshot = snapshot else {
                        print("ERROR FETCHING SNAPSHOT DATA: ")
                        return
                    }
                    
                    let documents = querySnapshot.documents
                    //deletes all friends locally
                    guard let savedFriendEntities = self?.coreDataController.savedFriendEntities else { return }
                    for friend in savedFriendEntities {
                        self?.coreDataController.deleteFriendLocally(friend: friend)
                    }
                    for document in documents {
                        let friendCodeID = document.data()[Constants.friendCodeID] as? String ?? "????"
                        let friendUserID = document.data()[Constants.friendUserID] as? String ?? ""
                        let friendDisplayName = document.data()[Constants.friendDisplayName] as? String ?? ""
                        let isFriend = document.data()[Constants.isFriend] as? Bool ?? false
                        let isFavorite = document.data()[Constants.isFavorite] as? Bool ?? false
                        self?.coreDataController.addFriend(friendCodeID: friendCodeID, friendUserID: friendUserID, friendDisplayName: friendDisplayName, isFriend: isFriend, isFavorite: isFavorite)
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
                if let bundleIdentifier = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
//                    KeychainHelper.clearKeychain()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

