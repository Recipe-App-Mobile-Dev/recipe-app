//
//  AuthModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 19/04/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

class AuthModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var email = ""
    @Published var password = ""
    @Published var profile: UserProfile = UserProfile(uid: "", name: "Loading...", icon: "defaultIcon.jpeg")
    private var profileRepository = UserProfileRepository()
    
    init(testProfile: Bool? = false) {
        if let test = testProfile, test == true  {
            self.profile = UserProfile(uid: "8t4KSPZAvzclXoCzBpOQZifge0m2", name: "test", icon: "defaultIcon.jpeg")
        } else {
            observeAuthChanges()
        }
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isSignedIn = user != nil
                
                guard let user = user else { return }
                print("User \(user.uid) signed in.")
                
                if let auth = self {
                    auth.profileRepository.fetchProfile(userId: user.uid) { (profile, error) in
                        if let error = error {
                            print("Error while fetching the user profile: \(error)")
                            return
                        }
                        
                        if let profile = profile {
                            auth.profile = profile
                            auth.isSignedIn = true
                        } else {
                            print("Error: User profile not found.")
                        }
                    }
                }
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in: \(error)")
                completion(false)
                return
            }
            
            guard let user = result?.user else { return }
            print("User \(user.uid) signed in.")
            
            self.profileRepository.fetchProfile(userId: user.uid) { (profile, error) in
                if let error = error {
                    print("Error while fetching the user profile: \(error)")
                    completion(false)
                    return
                }
                
                if let profile = profile {
                    self.profile = profile
                    self.isSignedIn = true
                    completion(true)
                } else {
                    print("Error: User profile not found.")
                }
            }
        }
    }
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing up: \(error)")
                completion(false)
                return
            }
            
            guard let user = result?.user else { return }
            print("User \(user.uid) signed up.")
            
            let userProfile = UserProfile(uid: user.uid, name: name, icon: "defaultIcon.jpeg")
            self.profileRepository.createProfile(profile: userProfile) { (profile, error) in
                if let error = error {
                    print("Error while fetching the user profile: \(error)")
                    completion(false)
                    return
                }
                
                guard let profile = profile else { return }
                
                self.profile = profile
                self.isSignedIn = true
                completion(true)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedIn = false
            self.profile = UserProfile(uid: "", name: "Loading...", icon: "defaultIcon.jpeg")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
