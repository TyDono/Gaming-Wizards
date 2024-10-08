//
//  AuthenticationViewModel.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/19/22.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import GoogleSignIn
import SwiftUI
import AuthenticationServices
import CryptoKit
import CoreData
import Security
import Combine

 class AuthenticationViewModel: ObservableObject {
    
    @AppStorage(Constants.appStorageStringLogStatus) var log_Status = false
    @ObservedObject var user = UserObservable.shared
    @ObservedObject var locationManager = LocationManager()
    var diskSpace = DiskSpaceHandler()
    @Published var currentNonce: String = ""
    @Published var signInState: SignInState = .signedOut
    @Published var isLoading: Bool = false
    @Published var signingIn: String = ""
    @Published var myFriendListData: [Friend] = []
    @Published var isUserLoggingInLoading: Bool = false
    @Published var loadingProgress: Double = 0.0
    @State var coreDataController: CoreDataController
    private var listeningRegistration: ListenerRegistration?
    static let sharedAuthenticationVM = AuthenticationViewModel()
    // The firestore and storage need to be directly called here in coredata as for what ever reason the configure doesn't go through in time.
    @ObservedObject var fbFirestoreHelper = FirebaseFirestoreHelper.shared
    @ObservedObject var fbStorageHelper = FirebaseStorageHelper.shared
//    private let keychainHelper = KeychainHelper()
    @Published private var savedFriendEntities: [FriendEntity] = []
    @Published private var blockedUserEntities: [BlockedUserEntity] = []
    private var cancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    private init(coreDataController: CoreDataController = CoreDataController.shared) {
        self.coreDataController = coreDataController
    }

    enum SignInState {
        case signedIn
        case signedOut
  }
    
    func callCoreDataEntities() async {
        self.cancellable = coreDataController.fetchFriendEntitiesPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { friends in
                self.savedFriendEntities = friends
            }
        self.cancellable = coreDataController.fetchBlockedUserEntitiesPublisher()
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }) { blockedUser in
                        self.blockedUserEntities = blockedUser
                    }
    }
    
    func saveUserIntoFirestore(for user: User) async {
        do {
            let documentPath = fbFirestoreHelper.firestore.collection(Constants.usersString).document(user.id)
            let document = try await documentPath.getDocument()
            if document.exists == true {
                if let documentData = document.data() {
                    do {
                        //get existing user from firestore
                        let decoder = Firestore.Decoder()
                        let existingUser = try decoder.decode(User.self, from: documentData)
                        self.fbStorageHelper.retrieveUserProfileImage(imageString: existingUser.profileImageString) { profileImage in
                            if let image = profileImage {
                                self.diskSpace.saveProfileImageToDisc(imageString: existingUser.profileImageString, image: image)
                            }
                        }
                        self.saveUserToUserDefaults(user: existingUser) {
                            Task.detached {
                                await self.retrieveFriendsListener()
                                await self.fbFirestoreHelper.retrieveBlockedUsers(userId: existingUser.id)
                                await self.fbFirestoreHelper.updateUserDeviceInFirestore()
                                await self.callFetchUserSearchSettings(userId: user.id)
                                await self.signInSuccess()
                            }
                        }
                        // add image from storage here. get the image from cloud storage using document.profileImageString. then save the image to disk
                    } catch {
                        print("Error decoding Firestore data: \(error.localizedDescription)")
                        await signOut()
                        return
                    }
                }
            } else {
                //create new user in firestore
                try await documentPath.setData(user.userDictionary)
                self.saveUserToUserDefaults(user: user) {
                    Task.detached {
                        guard let searchSettings = await self.coreDataController.createBaselineSearchSettings() else { return }
                        await self.retrieveFriendsListener()
                        await self.signInSuccess()
                    }
                }
            }
        } catch {
            print("ERROR RETRIEVING FIRESTORE USER DATA WHEN SIGNING IN: \(error.localizedDescription)")
            await signOut()
            return
        }
    }
    
    private func callFetchUserSearchSettings(userId: String) async {
        Task {
            guard let searchSettings = await fbFirestoreHelper.fetchUserSearchSettings(userId: userId) else { return }
            coreDataController.saveUserSearchSettingsToCoreData(searchSettings)
//            await self.fbFirestoreHelper.saveUserSearchSettings(userId: user.id, searchSettings: searchSettings)
        }
    }
    
    private func signInSuccess() {
        self.signInState = .signedIn
        self.isLoading = false
        self.isUserLoggingInLoading = false
        self.log_Status = true
    }
    
    private func saveUserToUserDefaults(user newUser: User, completion: @escaping () -> Void) {
        KeychainHelper.saveUserID(userID: newUser.id)
        user.firstName = newUser.firstName
        user.lastName = newUser.lastName
        user.displayName = newUser.displayName
        user.email = newUser.email ?? ""
        user.latitude = newUser.latitude
        user.longitude = newUser.longitude
        user.location = newUser.location
        user.profileImageString = newUser.profileImageString
        user.listOfGames = newUser.listOfGames
        user.groupSize = newUser.groupSize
        user.age = newUser.age
        user.about = newUser.about
        user.availability = newUser.availability
        user.title = newUser.title
        user.isPayToPlay = newUser.isPayToPlay
        user.isSolo = newUser.isSolo
        user.deviceInfo = newUser.deviceInfo
        user.dateFirstInstalled = newUser.dateFirstInstalled
        
        completion()
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
    
    func createUserBaseData(id: String, firstName: String, lastName: String, displayName: String, email: String?, completion: @escaping (User) -> Void) {
        let displayName = displayName
        let latitude = 0.0
        let longitude = 0.0
        let location = ""
        let profileImageString = "\(UUID().uuidString).jpg"
//        let friendID = String((UUID().uuidString.suffix(4)))
        let games: [String] = []
        let groupSize = ""
        let age = ""
        let about = ""
        let availability = ""
        let title = ""
        let isSolo = true
        let payToPlay = false
        let deviceModel = DeviceInfo.getDeviceInfo()
        let dateFirstInstalled = Date()
        var newUser = User(id: id,
                           firstName: firstName,
                           lastName: lastName,
                           displayName: displayName,
                           email: email,
                           latitude: latitude,
                           longitude: longitude,
                           location: location,
                           profileImageString: profileImageString,
                           listOfGames: games,
                           groupSize: groupSize,
                           age: age,
                           about: about,
                           availability: availability,
                           title: title,
                           isPayToPlay: payToPlay,
                           isSolo: isSolo,
                           deviceInfo: deviceModel,
                           dateFirstInstalled: dateFirstInstalled)
        locationManager.requestUserLocation { lat, long, city, state  in
            if let safeCity = city, let safeState = state {
                newUser.location = "\(safeCity), \(safeState)"
            } else {
                newUser.location = "\(city), \(state)"
            }
            newUser.latitude = lat
            newUser.longitude = long
            completion(newUser)
        }
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
    
    func deleteFriendInFirestore(friend: FriendEntity, userID: String) { //later when you get help, move the deleting of you from their friend list to be the first action then from your own list, and then locally,
//        guard let userFriendCodeID = user.friendCodeID else { return }
        guard let friendUserID = friend.id else { return }
//        guard let friendCodeID = friend.friendCodeID else { return }
        fbFirestoreHelper.firestore.collection(Constants.usersString).document(friendUserID).collection(Constants.userFriendList).document(user.id)
            .delete() { [weak self] err in
                if let error = err {
                    print("ERROR DELETING YOURSELF FROM YOUR FRIEND'S FRIEND LIST: \(error.localizedDescription)")
                } else {
                    guard let self = self else { return }
                    self.fbFirestoreHelper.firestore.collection(Constants.usersString).document(userID).collection("friendList").document(friendUserID).delete() { [weak self] err in
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
        let userID = user.id
        listeningRegistration = fbFirestoreHelper.firestore.collection(Constants.usersString)
            .document(userID)
            .collection(Constants.userFriendList)
            .addSnapshotListener { [weak self] snapshot, err in
                if let error = err {
                    print("ERROR GETTING FRIEND LIST DOCUMENTS: \(error.localizedDescription)")
                } else {
                    guard let self = self else { return }
                    guard let querySnapshot = snapshot else {
                        print("ERROR FETCHING SNAPSHOT DATA")
                        return
                    }
                    let documents = querySnapshot.documents
                    for document in documents {
                        do {
                            let existingFriend = try document.data(as: Friend.self)
                            let friend = existingFriend
                            self.coreDataController.saveFriend(friend: friend)
                                .receive(on: DispatchQueue.main)
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        break
                                    case .failure(let error):
                                        print("FAILED TO SAVE FRIEND TO CORE DATA: \(error)")
                                    }
                                }, receiveValue: { savedEntity in
                                    // DO SOMETHING ITH THE SAVED ENTITY IF NEEDED
                                })
                                .store(in: &cancellables)
                        } catch {
                            print("ERROR DECODING FRIEND: \(error.localizedDescription)")
                        }
                    }
                }
            }
    }
    
    func signOut() async {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            signInState = .signedOut
                log_Status = false
                self.isLoading = false
                self.isUserLoggingInLoading = false
                if let bundleIdentifier = Bundle.main.bundleIdentifier {
                    KeychainHelper.clearKeychain()
                    await coreDataController.clearAllData()
                    UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
                }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

