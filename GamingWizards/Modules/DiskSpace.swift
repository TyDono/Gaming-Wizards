//
//  DiskSpace.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/3/23.
//

import Foundation
import UIKit

class DiskSpace: ObservableObject {
    
     func saveProfileImageToDisc(imageString: String, image: UIImage) {
//        guard let image = image else { return }

        guard let data = image.jpegData(compressionQuality: 1.0) else { return }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageString)
        do {
            try data.write(to: fileURL)
            print("Image saved to disk.")
        } catch {
            print("ERROR SAVING PROFILE IMAGE TO DISC: \(error.localizedDescription)")
        }
    }
    
     func loadProfileImageFromDisk(imageString: String) -> UIImage {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageString)

        if let imageData = try? Data(contentsOf: fileURL),
           let loadedImage = UIImage(data: imageData) {
            return loadedImage
//            image = loadedImage
        } else {
            print("Failed to load image from disk, or no image")
            return UIImage(named: "WantedWizard")!
        }
    }
}
