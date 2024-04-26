//
//  RecipesView.swift
//  Recipe App
//
//  Created by Jin Mizuno on 16/04/2024.
//

import SwiftUI
import Foundation

struct RecipesView: View {
    @ObservedObject var viewModel: RecipesViewModel
    var authModel: AuthModel

    init(recipes: [RecipeModel], authModel: AuthModel) {
        viewModel = RecipesViewModel(recipes: recipes)
        self.authModel = authModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.recipes, id: \.recipeName) { recipe in
                    NavigationLink(destination: LazyView(RecipeView(recipe: recipe))) {
                        RecipeCardView(imageName: recipe.imageName, recipeName: recipe.recipeName)
                    }
                }
            }
            .padding()
            Button("Log Out") {
                authModel.signOut()
           }
        }
        .navigationBarTitle("App Name", displayMode: .inline)
        .navigationBarItems(
            leading: NavigationLink(destination: AddRecipeView()) {
                Image(systemName: "plus")
            },
            trailing: Button(action: {
                // Action for searching
            }) {
                Image(systemName: "magnifyingglass")
            }
        )
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView(recipes: RecipesDummyData.recipes, authModel: AuthModel())
    }
}
