//
//  User.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/7/22.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: String
    var firstName: String? = ""
    var lastName: String? = ""
    var displayName: String? = ""
    var email: String? = ""
    var latitude: Double?
    var longitude: Double?
    var location: String? = "" //change to UserLocation later date maybe
    var profileImageString: String = ""
    var friendCodeID = ""
//    var friendList: [Friend] = [] // sub collection
//    var friendRequests: [Friend] = [] // sub collection
    var listOfGames: [String]? = []
    var groupSize: String? = ""
    var age: String? = "" // change to an array of Int
    var about: String? = ""
    var availability: String? = ""
    var title: String? = ""
    var isPayToPlay: Bool = false
    var isSolo: Bool = true
    
    var userDictionary: [String: Any] {
        return [
            Constants.userID: id,
            Constants.userFirstName: firstName,
            Constants.userLastName: lastName,
            Constants.userDisplayName: displayName,
            Constants.userEmail: email ?? "No Email Available",
            Constants.userLatitude: latitude,
            Constants.userLongitude: longitude,
            Constants.userLocation: location,
            Constants.userProfileImageString: profileImageString,
            Constants.userFriendCodeID: friendCodeID,
//            Constants.userFriendList: friendList,
//            Constants.userFriendRequest: friendRequests,
            Constants.userListOfGamesString: listOfGames,
            Constants.userGroupSize: groupSize,
            Constants.userAge: age,
            Constants.userAbout: about,
            Constants.userAvailability: availability,
            Constants.userTitle: title,
            Constants.userPayToPlay: isPayToPlay,
            Constants.userIsSolo: isSolo
            
        ]
    }
}

extension User {
    enum UserCodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case displayName = "displayName"
        case email = "email"
        case latitude = "latitude"
        case longitude = "longitude"
        case location = "userLocation"
        case profileImageString = "profileImageString"
        case friendCodeID = "friendCodeID"
//        case friendList = "friendList"
//        case friendRequests = "friendRequests"
        case listOfGames = "listOfGames"
        case groupSize = "groupSize"
        case age = "age"
        case about = "about"
        case availability = "availability"
        case title = "title"
        case payToPlay = "isPayToPlay"
        case isSolo = "isSolo"
        
        init?(constantValue: String) {
            switch constantValue {
            case Constants.userID:
                self = .id
            case Constants.userFirstName:
                self = .firstName
            case Constants.userLastName:
                self = .lastName
            case Constants.userDisplayName:
                self = .displayName
            case Constants.userEmail:
                self = .email
            case Constants.userLatitude:
                self = .latitude
            case Constants.userLocation:
                self = .longitude
            case Constants.userLocation:
                self = .location
            case Constants.userProfileImageString:
                self = .profileImageString
            case Constants.userFriendCodeID:
                self = .friendCodeID
            case Constants.userListOfGamesString:
                self = .listOfGames
            case Constants.userGroupSize:
                self = .groupSize
            case Constants.userAge:
                self = .age
            case Constants.userAbout:
                self = .about
            case Constants.userAvailability:
                self = .availability
            case Constants.userTitle:
                self = .title
            case Constants.userPayToPlay:
                self = .payToPlay
            case Constants.userIsSolo:
                self = .isSolo
            default:
                return nil
            }
        }
        
    }
}
        
class UserObservable: ObservableObject {
    static let shared = UserObservable()
    
    private let idKey = Constants.userID
    private let firstNameKey = Constants.userFirstName
    private let lastNameKey = Constants.userLastName
    private let displayNameKey = Constants.userDisplayName
    private let emailKey = Constants.userEmail
    private let latitudeKey = Constants.userLatitude
    private let longitudeKey = Constants.userLongitude
    private let locationKey = Constants.userLocation
    private let profileImageStringKey = Constants.userProfileImageString
    private let isNewUserKey = "isNewUser" // No constant provided for this, so using the original string
    private let friendIDKey = Constants.userFriendCodeID
    private let friendListKey = Constants.userFriendList
    private let friendRequestsKey = Constants.userFriendRequest
    private let listOfGamesKey = Constants.userListOfGamesString
    private let groupSizeKey = Constants.userGroupSize
    private let ageKey = Constants.userAge
    private let aboutKey = Constants.userAbout
    private let availabilityKey = Constants.userAvailability
    private let titleKey = Constants.userTitle
    private let payToPlayKey = Constants.userPayToPlay
    private let isSoloKey = Constants.userIsSolo
    
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
    
    @Published var email: String {
        didSet {
            UserDefaults.standard.setValue(email, forKey: "\(emailKey)-\(id)")
        }
    }
    
    @Published var latitude: Double? {
        didSet {
            UserDefaults.standard.setValue(latitude, forKey: "\(latitudeKey)-\(id)")
        }
    }
    
    @Published var longitude: Double? {
        didSet {
            UserDefaults.standard.setValue(longitude, forKey: "\(longitudeKey)-\(id)")
        }
    }
    
    @Published var location: String? {
        didSet {
            UserDefaults.standard.setValue(location, forKey: "\(locationKey)-\(id)")
        }
    }
    
    @Published var profileImageString: String {
        didSet {
            UserDefaults.standard.setValue(profileImageString, forKey: "\(profileImageStringKey)-\(id)")
        }
    }
    
    @Published var isNewUser: Bool? {
        didSet {
            UserDefaults.standard.setValue(isNewUser, forKey: "\(isNewUserKey)-\(id)")
        }
    }
    
    @Published var friendCodeID: String {
        didSet {
            UserDefaults.standard.setValue(friendCodeID, forKey: "\(friendIDKey)-\(id)")
        }
    }
    
//    @Published var friendList: [Friend] { // Saved in CoreData
//        didSet {
//            UserDefaults.standard.set(friendList, forKey: "\(friendListKey)-\(id)")
//        }
//    }
    
    @Published var listOfGames: [String]? {
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
    
    @Published var isPayToPlay: Bool {
        didSet {
            UserDefaults.standard.setValue(isPayToPlay, forKey: "\(payToPlayKey)-\(id)")
        }
    }
    
    @Published var isSolo: Bool {
        didSet {
            UserDefaults.standard.setValue(isSolo, forKey: "\(isSoloKey)-\(id)")
        }
    }
    
    private init() {
//        guard let userId = KeychainHelper.getUserID() else {
//            // Crashes the app, post mvp on just log them out and take them back to log in screen.
//            print("USER ID NOT FOUND WHEN TRYING TO INIT USER OBSERVABLE.")
//            return
//            }
        var userId: String = {
            if let userId = KeychainHelper.getUserID() {
                return userId
            } else {
                // Provide a default value here
                print("USER ID NOT FOUND WHEN TRYING TO INIT USER OBSERVABLE.")
                return "defaultUserId is nil"
            }
        }()
        id = userId
        firstName = UserDefaults.standard.string(forKey: "\(firstNameKey)-\(id)") ?? ""
        lastName = UserDefaults.standard.string(forKey: "\(lastNameKey)-\(id)") ?? ""
        displayName = UserDefaults.standard.string(forKey: "\(displayNameKey)-\(id)") ?? ""
        email = UserDefaults.standard.string(forKey: "\(emailKey)-\(id)") ?? ""
        latitude = UserDefaults.standard.double(forKey: "\(latitudeKey)-\(id)")
        longitude = UserDefaults.standard.double(forKey: "\(longitudeKey)-\(id)")
        location = UserDefaults.standard.string(forKey: "\(locationKey)-\(id)") ?? ""
        profileImageString = UserDefaults.standard.string(forKey: "\(profileImageStringKey)-\(id)") ?? ""
        isNewUser = UserDefaults.standard.bool(forKey: "\(isNewUserKey)-\(id)")
        friendCodeID = UserDefaults.standard.string(forKey: "\(friendIDKey)-\(id)") ?? ""
        groupSize = UserDefaults.standard.string(forKey: "\(groupSizeKey)-\(id)") ?? ""
        listOfGames = UserDefaults.standard.array(forKey: "\(listOfGamesKey)-\(id)") as? [String] ?? []
        age = UserDefaults.standard.string(forKey: "\(ageKey)-\(id)") ?? ""
        about = UserDefaults.standard.string(forKey: "\(aboutKey)-\(id)") ?? ""
        availability = UserDefaults.standard.string(forKey: "\(availabilityKey)-\(id)") ?? ""
        title = UserDefaults.standard.string(forKey: "\(titleKey)-\(id)") ?? ""
        isPayToPlay = UserDefaults.standard.bool(forKey: "\(payToPlayKey)-\(id)")
        isSolo = UserDefaults.standard.bool(forKey: "\(isSoloKey)-\(id)")
    }
}
