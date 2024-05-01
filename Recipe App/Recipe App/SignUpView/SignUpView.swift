import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel
    
    init(authModel: AuthModel) {
           _viewModel = StateObject(wrappedValue: SignUpViewModel(authModel: authModel))
       }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                Text("Hello,")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Create an account")
                    .font(.title2)
                    .fontWeight(.light)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 20) {
                CustomTextField(label: "Name", placeHolder: "Enter Name", text: $viewModel.name, keyboardType: .default)
                CustomTextField(label: "Email", placeHolder: "Enter Email", text: $viewModel.email, keyboardType: .emailAddress)
                CustomTextField(label: "Password", placeHolder: "Enter Password", text: $viewModel.password, isSecure: true)
                CustomTextField(label: "Confirm Password", placeHolder: "Retype Password Again", text: $viewModel.passwordConfirmation, isSecure: true)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            Button(action: viewModel.signUp) {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Sign in to your account")
            
            Spacer()
            
            HStack {
                Text("Already a member?")
                    .font(.footnote)
                NavigationLink(destination: LoginView(authModel: viewModel.authModel)) {
                    Text("Log in")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(authModel: AuthModel())
    }
}


