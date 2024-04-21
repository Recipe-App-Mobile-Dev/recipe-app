//
//  ContentView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.04.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authModel: AuthModel = AuthModel()
    
    var body: some View {
        NavigationView {
            if authModel.isSignedIn {
                RecipesView(recipes: RecipesDummyData.recipes)
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
