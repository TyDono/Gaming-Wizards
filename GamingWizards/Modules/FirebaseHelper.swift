//
//  FirebaseHelper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/5/23.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class FirebaseHelper {
    let user = UserObservable.shared
    let firestoreDatabase = Firestore.firestore()
    let storageRef = Storage.storage()
    
    func searchForMatchingGames(collectionName: String, whereField: String, gameName: String) async throws -> [User] {
        let gameQuery = firestoreDatabase.collection(collectionName).whereField(whereField, arrayContains: gameName)
//            let gameQuery = firesStoreDatabase.collection(Constants.users).whereField(Constants.userListOfGamesString, arrayContains: gameName)
        
        do {
            let snapshot = try await gameQuery.getDocuments()
            let users = snapshot.documents.map { document -> User in
                let data = document.data()
                let id = data[Constants.userID] as? String ?? ""
                let displayName = data[Constants.userDisplayName] as? String ?? ""
                let email = data[Constants.userEmail] as? String ?? ""
                let location = data[Constants.userLocation] as? String ?? ""
                let profileImageString = data[Constants.userProfileImageString] as? String ?? ""
                let friendCodeID = data[Constants.userFriendID] as? String ?? ""
                let listOfGames = data[Constants.userListOfGamesString] as? [String] ?? [""]
                let groupSize = data[Constants.userGroupSize] as? String ?? ""
                let age = data[Constants.userAge] as? String ?? ""
                let about = data[Constants.userAbout] as? String ?? ""
                let availability = data[Constants.userAvailability] as? String ?? ""
                let title = data[Constants.userTitle] as? String ?? ""
                let payToPlay = data[Constants.userPayToPlay] as? Bool ?? false
                let isSolo = data[Constants.userIsSolo] as? Bool ?? true
                
                return User(id: id, displayName: displayName, email: email, location: location, profileImageString: profileImageString, friendCodeID: friendCodeID, listOfGames: listOfGames, groupSize: groupSize, age: age, about: about, availability: availability, title: title, isPayToPlay: payToPlay, isSolo: isSolo)
            }
            
            return users
        } catch {
            print("ERROR FETCHING SEARCHED FOR USERS: \(error.localizedDescription)")
            throw error
        }
    }
    
    func retrieveUserProfileImage(imageString: String, completion: @escaping (UIImage?) -> Void) {
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
    
}
