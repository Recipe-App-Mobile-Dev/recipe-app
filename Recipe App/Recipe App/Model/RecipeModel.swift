//
//  RecipeModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

struct RecipeModel: Identifiable {
    let id = UUID()
    let recipeName: String
    let imageName: String
    let recipeDescription: String?
    let ingredients: [Ingredient: String]
    let steps: [Step]
    
    struct Step {
        let stepNumber: Int
        let description: String
        let stepImage: String?
    }
}
