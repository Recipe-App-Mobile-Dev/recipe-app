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
    
    init() {
        observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isSignedIn = user != nil
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.isSignedIn = true
                }
            }
        }
        completion(true)
    }
    
    func signUp(name: String, email: String, password: String, passwordConfirmation: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if result != nil, error == nil {
                    self?.isSignedIn = true
                }
            }
        }
        completion(true)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
