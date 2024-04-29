//
//  RecipeViewModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var recipe: RecipeModel?
    private var recipesRepository = RecipesRepository()
    
    
    init(recipe: RecipeModel) {
        fetchRecipe(recipe: recipe)
    }
    
    
    func fetchRecipe(recipe: RecipeModel) {
        recipesRepository.fetchRecipeInfo(forRecipe: recipe) { [weak self] recipe, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the recipe: \(error)")
                return
            } else {
                self.recipe = recipe
            }
        }
    }

    
    func deleteRecipe(completion: @escaping () -> Void) {
        if let id = recipe?.id {
            recipesRepository.deleteRecipe(recipeId: id) { error in
                if let error = error {
                    print("Error deleting recipe: \(error.localizedDescription)")
                } 
            }
        }
    }
    
    // func editRecipe
    // func rateRecipe
}
