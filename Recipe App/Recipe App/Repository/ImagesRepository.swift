//
//  ImagesRepository.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 28.04.2024.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

class ImagesRepository: ObservableObject {
    private let storage = Storage.storage()
    private let storageRef = Storage.storage().reference()
    
    func getImage(name: String, completion: @escaping (Image?) -> Void) {
        let imageRef = storageRef.child(name)
        print(imageRef)
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else {
                // If image data is downloaded successfully, create SwiftUI Image
                if let imageData = data, let uiImage = UIImage(data: imageData) {
                    let image = Image(uiImage: uiImage)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
