//
//  User.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: String
    var firstName = ""
    var lastName = ""
    var displayName = ""
    var email: String? = ""
    var location: String = "" //change to UserLocation later date maybe
    var profileImageString = ""
    var friendCodeID = ""
    var friendList: [Friend] = [] // sub collection
    var friendRequests: [Friend] = [] // sub collection
    var listOfGames: [String] = []
    var groupSize: String = ""
    var age: String = "" // change to an array of Int
    var about: String = ""
    var availability: String = ""
    var title: String = ""
    var isPayToPlay: Bool = false
    var isSolo: Bool = true
    
    var userDictionary: [String: Any] {
        return [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "displayName": displayName,
            "email": email ?? "No Email Available",
            "location": location,
            "profileImageString": profileImageString,
            "friendCodeID": friendCodeID,
            "friendList": friendList,
            "friendRequests": friendRequests,
            "listOfGames": listOfGames,
            "groupSize": groupSize,
            "age": age,
            "about": about,
            "availability": availability,
            "title": title,
            "isPayToPlay": isPayToPlay,
            "isSolo": isSolo
            
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
        case profileImageString = "profile_image_string"
        case friendCodeID = "friendCodeID"
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
    }
}
        
class UserObservable: ObservableObject {
    static let shared = UserObservable()
    
    private let idKey = "id"
    private let firstNameKey = "firstName"
    private let lastNameKey = "lastName"
    private let displayNameKey = "displayName"
    private let emailKey = "email"
    private let locationKey = "location"
    private let profileImageStringKey = "profileImageString"
    private let isNewUserKey = "isNewUser"
    private let latitudeKey = "latitude"
    private let longitudeKey = "longitude"
    private let friendIDKey = "friendCodeID"
    private let friendListKey = "friendList"
    private let friendRequestsKey = "friendRequests"
    private let listOfGamesKey = "listOfGames"
    private let groupSizeKey = "groupSize"
    private let ageKey = "age"
    private let aboutKey = "about"
    private let availabilityKey = "availability"
    private let titleKey = "title"
    private let payToPlayKey = "isPayToPlay"
    private let isSoloKey = "isSolo"
    
    var id: String
    
//    @Published var id: String {
//        didSet {
//            UserDefaults.standard.setValue(id, forKey: "\(idKey)-\(id)")
//        }
//    }
    
    @Published var firstName: String? {
        didSet {
            UserDefaults.standard.setValue(firstName, forKey: "\(firstNameKey)-\(id)")
        }
    }
    
    @Published var lastName: String? {
        didSet {
            UserDefaults.standard.setValue(lastName, forKey: "\(lastNameKey)-\(id)")
        }
    }
    
    @Published var displayName: String? {
        didSet {
            UserDefaults.standard.setValue(displayName, forKey: "\(displayNameKey)-\(id)")
        }
    }
    
    @Published var email: String? {
        didSet {
            UserDefaults.standard.setValue(email, forKey: "\(emailKey)-\(id)")
        }
    }
    
    @Published var location: String? {
        didSet {
            UserDefaults.standard.setValue(location, forKey: "\(locationKey)-\(id)")
        }
    }
    
    @Published var profileImageString: String? {
        didSet {
            UserDefaults.standard.setValue(profileImageString, forKey: "\(profileImageStringKey)-\(id)")
        }
    }
    
    @Published var isNewUser: Bool? {
        didSet {
            UserDefaults.standard.setValue(isNewUser, forKey: "\(isNewUserKey)-\(id)")
        }
    }
    
    @Published var latitude: Double? {
        didSet {
            UserDefaults.standard.setValue(latitude, forKey: latitudeKey)
        }
    }
    
    @Published var longitude: Double? {
        didSet {
            UserDefaults.standard.setValue(longitude, forKey: longitudeKey)
        }
    }
    
    @Published var friendCodeID: String? {
        didSet {
            UserDefaults.standard.setValue(friendCodeID, forKey: "\(friendIDKey)-\(id)")
        }
    }
    
//    @Published var friendList: [Friend] { // Saved in CoreData
//        didSet {
//            UserDefaults.standard.set(friendList, forKey: "\(friendListKey)-\(id)")
//        }
//    }
    
    @Published var listOfGames: [String?] {
        didSet {
            UserDefaults.standard.setValue(listOfGames, forKey: "\(listOfGamesKey)-\(id)")
        }
    }
    
    @Published var groupSize: String? {
        didSet {
            UserDefaults.standard.setValue(groupSize, forKey: "\(groupSizeKey)-\(id)")
        }
    }
    
    @Published var age: String? {
        didSet {
            UserDefaults.standard.setValue(age, forKey: "\(ageKey)-\(id)")
        }
    }
    
    @Published var about: String? {
        didSet {
            UserDefaults.standard.setValue(about, forKey: "\(aboutKey)-\(id)")
        }
    }
    
    @Published var availability: String? {
        didSet {
            UserDefaults.standard.setValue(availability, forKey: "\(availabilityKey)-\(id)")
        }
    }
    
    
    @Published var title: String? {
        didSet {
            UserDefaults.standard.setValue(title, forKey: "\(titleKey)-\(id)")
        }
    }
    
    @Published var isPayToPlay: Bool? {
        didSet {
            UserDefaults.standard.setValue(isPayToPlay, forKey: "\(payToPlayKey)-\(id)")
        }
    }
    
    @Published var isSolo: Bool? {
        didSet {
            UserDefaults.standard.setValue(isSolo, forKey: "\(isSoloKey)-\(id)")
        }
    }
    
    func setId(to newId: String) {
        UserDefaults.standard.setValue(newId, forKey: idKey)
    }
    
    private init() {
        id = KeychainHelper.getUserID() ?? "NO ID FOUND"
        firstName = UserDefaults.standard.string(forKey: "\(firstNameKey)-\(id)") ?? ""
        lastName = UserDefaults.standard.string(forKey: "\(lastNameKey)-\(id)") ?? ""
        displayName = UserDefaults.standard.string(forKey: "\(displayNameKey)-\(id)") ?? ""
        email = UserDefaults.standard.string(forKey: "\(emailKey)-\(id)") ?? ""
        location = UserDefaults.standard.string(forKey: "\(locationKey)-\(id)") ?? ""
        profileImageString = UserDefaults.standard.string(forKey: "\(profileImageStringKey)-\(id)") ?? ""
        isNewUser = UserDefaults.standard.bool(forKey: "\(isNewUserKey)-\(id)")
        latitude = UserDefaults.standard.double(forKey: latitudeKey)
        longitude = UserDefaults.standard.double(forKey: longitudeKey)
        friendCodeID = UserDefaults.standard.string(forKey: "\(friendIDKey)-\(id)") ?? ""
        groupSize = UserDefaults.standard.string(forKey: "\(groupSizeKey)-\(id)") ?? ""
        listOfGames = UserDefaults.standard.array(forKey: "\(listOfGamesKey)-\(id)") as? [String] ?? []
        age = UserDefaults.standard.string(forKey: "\(ageKey)-\(id)") ?? ""
        about = UserDefaults.standard.string(forKey: "\(aboutKey)-\(id)") ?? ""
        availability = UserDefaults.standard.string(forKey: "\(availabilityKey)-\(id)") ?? ""
        title = UserDefaults.standard.string(forKey: "\(titleKey)-\(id)") ?? ""
        isPayToPlay = UserDefaults.standard.bool(forKey: "\(payToPlayKey)-\(id)") ?? false
        isSolo = UserDefaults.standard.bool(forKey: "\(isSoloKey)-\(id)") ?? true
    }
}
