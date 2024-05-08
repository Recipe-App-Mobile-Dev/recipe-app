//
//  FilteredRecipesView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.05.2024.
//

import Foundation
import SwiftUI

struct FilteredRecipesView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var auth: AuthModel
    
    init(searchViewModel: SearchViewModel, auth: AuthModel) {
        self.auth = auth
        self.searchViewModel = searchViewModel
    }
    
    var body: some View {
        VStack {
            if let foundRecipes = searchViewModel.filterRecipes() {
                List(foundRecipes) { recipe in
                    NavigationLink(destination: LazyView(RecipeView(recipe: recipe, auth: auth))) {
                        ListRecipeView(recipe: recipe)
                    }
                }
            } else {
                Text("Nothing found")
            }
        }
        .navigationTitle("Filtered Recipes")
    }
}

#Preview {
    FilteredRecipesView(
        searchViewModel: SearchViewModel(recipes: RecipesDummyData.recipes),
        auth: AuthModel(testProfile: true)
    )
}
