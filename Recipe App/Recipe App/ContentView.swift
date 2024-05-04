//
//  ContentView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.04.2024.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var authModel: AuthModel = AuthModel()
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $path) {
            if authModel.isSignedIn {
                RecipesView(authModel: authModel, path: $path)
            } else {
                LoginView(authModel: authModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
