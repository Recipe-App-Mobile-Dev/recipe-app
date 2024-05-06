//
//  ProfileEditViewModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 06/05/2024.
//

import Foundation
import SwiftUI

class ProfileEditViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published var editedName: String = ""
    @Published var selectedImage: UIImage?
    private var repository = UserProfileRepository()
    var onSaveCompleted: (() -> Void)?
    
    init(profile: UserProfile) {
        self.profile = profile
        self.editedName = profile.name
    }
    
    func saveProfileChanges() {
        profile.name = editedName
        
        repository.editProfile(profile: profile, image: selectedImage) { error in
            if let error = error {
                print("Failed to update profile: \(error)")
            } else {
                print("Profile successfully updated.")
                DispatchQueue.main.async {
                    self.onSaveCompleted?()
                }
            }
        }
    }
    
    func fetchUserProfile(userId: String) {
        repository.fetchProfile(userId: userId) { [weak self] profile, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                self.profile = profile!
            }
        }
    }
}
