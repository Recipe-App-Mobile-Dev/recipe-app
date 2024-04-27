//
//  RecipeViewModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipe: RecipeModel?
    private var recipesRepository = RecipesRepository()
    
    init(recipeId: String) {
        recipesRepository.fetchRecipe(id: recipeId) { (recipe, error) in
            if let error = error {
                print("Error while fetching the recipe: \(error)")
                return
            }
            self.recipe = recipe
        }
    }
    
    // func editRecipe
    // func deleteRecipe
    // func rateRecipe
}
