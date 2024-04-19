//
//  AuthModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 19/04/2024.
//

import Foundation
import SwiftUI

class AuthModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var email = ""
    @Published var password = ""
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        self.isSignedIn = true
        completion(true)
    }
    
    func signUp(name: String, email: String, password: String, passwordConfirmation: String, completion: @escaping (Bool) -> Void) {
        self.isSignedIn = true
        completion(true)
    }
}
