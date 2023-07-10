//
//  FirebaseStorageHelper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/10/23.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseStorageHelper {
    let user = UserObservable.shared
    let storageRef = Storage.storage()
    
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
