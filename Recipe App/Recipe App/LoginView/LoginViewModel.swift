//
//  LoginViewModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 19/04/2024.
//

import Foundation
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    var authModel: AuthModel

    init(authModel: AuthModel) {
        self.authModel = authModel
    }

    func login() {
        if !email.isEmpty && !password.isEmpty {
            authModel.login(email: email, password: password) { success in
                if !success {
                    self.errorMessage = "Invalid credentials."
                }
            }
        } else {
            errorMessage = "Please fill in all fields."
        }
    }
}
