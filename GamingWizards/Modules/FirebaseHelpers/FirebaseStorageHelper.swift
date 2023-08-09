//
//  FirebaseStorageHelper.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/10/23.
//

import Foundation
import FirebaseStorage
import UIKit

class FirebaseStorageHelper: NSObject, ObservableObject {
    let storage: Storage
    
    static let shared = FirebaseStorageHelper()
    
    override init() {
        self.storage = Storage.storage()
        
        super.init()
    }
    
    func retrieveUserProfileImage(imageString: String, completion: @escaping (UIImage?) -> Void) {
        let storagePath = storage.reference().child("profileImages/\(imageString)")
        storagePath.getData(maxSize: 3 * 1024 * 1024) { (data, error) in
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
