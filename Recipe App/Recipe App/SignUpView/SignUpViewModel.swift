//
//  SignUpViewModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 19/04/2024.
//

import Foundation
import Combine
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var errorMessage: String?
    var authModel: AuthModel

    init(authModel: AuthModel) {
        self.authModel = authModel
    }

    func signUp() {
        if name.isEmpty || email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
            errorMessage = "Please fill in all fields."
            return
        }
        
        if password != passwordConfirmation {
            errorMessage = "Passwords do not match."
            return
        }
        
        authModel.signUp(name: name, email: email, password: password) { success in
            if !success {
                self.errorMessage = "Invalid credentials."
            }
        }
    }
}
