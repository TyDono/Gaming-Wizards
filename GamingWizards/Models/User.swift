//
//  User.swift
//  Foodiii
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation
import Swift

struct User: Identifiable, Codable {
    var id: String
    var firstName = ""
    var lastName = ""
    var displayName = ""
    var email: String? = ""
    var location = ""
    var profileImageUrl = ""
    var friendID = ""
    var friendList: [Friend] = [] // sub collection
    var friendRequests: [Friend] = [] // sub collection
    
    var userDictionary: [String: Any] {
        return [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "displayName": displayName,
            "email": email ?? "No Email Available",
            "location": location,
            "profileImageUrl": profileImageUrl,
            "friendCodeID": friendID,
            "friendList": friendList,
            "friendRequests": friendRequests
        ]
    }
}

extension User {
    enum UserCodingKeys: String, CodingKey {
        case id = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case displayName = "display_Name"
        case email = "user_email"
        case location = "user_location"
        case profileImageUrl = "profile_image_url"
        case friendID = "friendCodeID"
        case friendList = "friendList"
        case friendRequests = "friendRequests"
    }
}
        
class UserObservable: ObservableObject {
    let idKey = "id"
    let firstNameKey = "firstName"
    let lastNameKey = "lastName"
    let displayNameKey = "displayName"
    let emailKey = "email"
    let locationKey = "location"
    let profileImageUrlKey = "profileImageUrl"
    let isNewUserKey = "isNewUser"
    let latitudeKey = "latitude"
    let longitudeKey = "longitude"
    let friendIDKey = "friendCodeID"
    let friendListKey = "friendList"
    let friendRequestsKey = "friendRequests"
    
    var id: String
    
    @Published var firstName: String {
        didSet {
            UserDefaults.standard.setValue(firstName, forKey: "\(firstNameKey)-\(id)")
        }
    }
    
    @Published var lastName: String {
        didSet {
            UserDefaults.standard.setValue(lastName, forKey: "\(lastNameKey)-\(id)")
        }
    }
    
    @Published var displayName: String {
        didSet {
            UserDefaults.standard.setValue(displayName, forKey: "\(displayNameKey)-\(id)")
        }
    }
    
    @Published var email: String {
        didSet {
            UserDefaults.standard.setValue(email, forKey: "\(emailKey)-\(id)")
        }
    }
    
    @Published var location: String {
        didSet {
            UserDefaults.standard.setValue(location, forKey: "\(locationKey)-\(id)")
        }
    }
    
    @Published var profileImageUrl: String {
        didSet {
            UserDefaults.standard.setValue(profileImageUrl, forKey: "\(profileImageUrlKey)-\(id)")
        }
    }
    
    @Published var isNewUser: Bool {
        didSet {
            UserDefaults.standard.setValue(isNewUser, forKey: "\(isNewUserKey)-\(id)")
        }
    }
    
    @Published var latitude: Double {
        didSet {
            UserDefaults.standard.setValue(latitude, forKey: latitudeKey)
        }
    }
    
    @Published var longitude: Double {
        didSet {
            UserDefaults.standard.setValue(longitude, forKey: longitudeKey)
        }
    }
    
    @Published var friendID: String {
        didSet {
            UserDefaults.standard.set(friendID, forKey: "\(friendIDKey)-\(id)")
        }
    }
    
//    @Published var friendList: [Friend] {
//        didSet {
//            UserDefaults.standard.set(friendList, forKey: "\(friendListKey)-\(id)")
//        }
//    }
    
    func setId(to newId: String) {
        UserDefaults.standard.setValue(newId, forKey: idKey)
    }
    
    init() {
        id = UserDefaults.standard.string(forKey: idKey) ?? ""
        firstName = UserDefaults.standard.string(forKey: "\(firstNameKey)-\(id)") ?? ""
        lastName = UserDefaults.standard.string(forKey: "\(lastNameKey)-\(id)") ?? ""
        displayName = UserDefaults.standard.string(forKey: "\(displayNameKey)-\(id)") ?? ""
        email = UserDefaults.standard.string(forKey: "\(emailKey)-\(id)") ?? ""
        location = UserDefaults.standard.string(forKey: "\(locationKey)-\(id)") ?? ""
        profileImageUrl = UserDefaults.standard.string(forKey: "\(profileImageUrlKey)-\(id)") ?? ""
        isNewUser = UserDefaults.standard.bool(forKey: "\(isNewUserKey)-\(id)")
        latitude = UserDefaults.standard.double(forKey: latitudeKey)
        longitude = UserDefaults.standard.double(forKey: longitudeKey)
        friendID = UserDefaults.standard.string(forKey: "\(friendIDKey)-\(id)") ?? ""
//        friendList = UserDefaults.standard.string(forKey: "\(friendIDKey)-\(id)")
    }
}
