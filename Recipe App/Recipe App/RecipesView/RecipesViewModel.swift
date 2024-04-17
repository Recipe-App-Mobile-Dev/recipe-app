//
//  RecipesViewModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 16/04/2024.
//

import Foundation

class RecipesViewModel: ObservableObject {
    @Published var recipes: [RecipeModel]
    
    init(recipes: [RecipeModel]) {
        self.recipes = recipes
    }
}

