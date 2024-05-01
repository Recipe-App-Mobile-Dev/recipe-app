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

    init(test: Bool? = false, authModel: AuthModel) {
        viewModel = RecipesViewModel(test: test)
        self.authModel = authModel
    }

    var body: some View {
        if let fetchedRecipes = viewModel.recipes {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(fetchedRecipes, id: \.recipeName) { recipe in
                        NavigationLink(destination: LazyView(RecipeView(recipe: recipe, auth: authModel))) {
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
        RecipesView(test: true, authModel: AuthModel())
    }
}
