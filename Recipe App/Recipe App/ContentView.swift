//
//  ContentView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.04.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            RecipesView(recipes: RecipesDummyData.recipes)
        }
    }
}

#Preview {
    ContentView()
}
