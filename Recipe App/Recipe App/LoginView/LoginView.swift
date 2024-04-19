import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    init(authModel: AuthModel) {
           _viewModel = StateObject(wrappedValue: LoginViewModel(authModel: authModel))
       }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                Text("Hello,")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Welcome Back!")
                    .font(.title2)
                    .fontWeight(.light)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 20) {
                CustomTextField(label: "Email", placeHolder: "Enter Email", text: $viewModel.email, keyboardType: .emailAddress)
                CustomTextField(label: "Password", placeHolder: "Enter Password", text: $viewModel.password, isSecure: true)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            Button(action: viewModel.login) {
                Text("Sign In")
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
                Text("Don't have an account?")
                    .font(.footnote)
                NavigationLink(destination: SignUpView(authModel: viewModel.authModel)) {
                    Text("Sign Up")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authModel: AuthModel())
    }
}

