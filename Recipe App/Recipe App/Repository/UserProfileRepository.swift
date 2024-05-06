//
//  UserProfileRepository.swift
//  Recipe App
//
//  Created by Jin Mizuno on 27/04/2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

class UserProfileRepository: ObservableObject {
  private var db = Firestore.firestore()
  private var storage = Storage.storage()

  func createProfile(profile: UserProfile, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
    do {
      let _ = try db.collection("user_profiles").document(profile.uid).setData(from: profile)
      completion(profile, nil)
    }
    catch let error {
      print("Error writing city to Firestore: \(error)")
      completion(nil, error)
    }
  }
    
  func editProfile(profile: UserProfile, image: UIImage?, completion: @escaping (_ error: Error?) -> Void) {
      if (image != nil){
          guard let imageData = image?.jpegData(compressionQuality: 0.5) else {
              completion(NSError(domain: "com.yourdomain.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image"]))
              return
          }
          
          let storageRef = storage.reference(withPath: "profiles/\(profile.uid)/profile.jpg")
          let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
              guard let metadata = metadata, error == nil else {
                  completion(error)
                  return
              }
              
              storageRef.downloadURL { (url, error) in
                  guard let downloadURL = url else {
                      completion(error)
                      return
                  }

                  self.db.collection("user_profiles").document(profile.uid).setData([
                      "name": profile.name,
                      "icon": downloadURL.absoluteString
                  ], merge: true) { error in
                      completion(error)
                  }
              }
          }
          
          uploadTask.observe(.failure) { snapshot in
              if let error = snapshot.error {
                  completion(error)
              }
          }
      } else {
          self.db.collection("user_profiles").document(profile.uid).setData([
              "name": profile.name
          ], merge: true) { error in
              completion(error)
          }
      }
  }

  func fetchProfile(userId: String, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
    db.collection("user_profiles").document(userId).getDocument { (snapshot, error) in
      let profile = try? snapshot?.data(as: UserProfile.self)
      completion(profile, error)
    }
  }
}
