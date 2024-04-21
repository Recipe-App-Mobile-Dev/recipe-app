//
//  CustomTextField.swift
//  Recipe App
//
//  Created by Jin Mizuno on 19/04/2024.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var label: String
    var placeHolder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.light)
            if isSecure {
                SecureField(placeHolder, text: $text)
                    .textFieldStyle(MyTextFieldStyle())
            } else {
                TextField(placeHolder, text: $text)
                    .keyboardType(keyboardType)
                    .textFieldStyle(MyTextFieldStyle())
            }
        }
    }
}

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray)
            )
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State static var text = ""
    static var previews: some View {
        CustomTextField(label: "Email", placeHolder: "Enter Email", text: $text, keyboardType: .emailAddress)
    }
}
