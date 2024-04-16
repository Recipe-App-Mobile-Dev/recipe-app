//
//  RecipeViewModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipe: RecipeModel
    
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
    
    // func editRecipe
    // func deleteRecipe
    // func rateRecipe
}
