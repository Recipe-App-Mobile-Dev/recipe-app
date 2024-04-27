//
//  RecipeModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

struct RecipeModel: Identifiable, Codable {
    let id: String
    let userId: String
    let recipeName: String
    let imageName: String
    let recipeDescription: String?
    let ingredients: [RecipeIngridient]
    let steps: [Step]
    
    struct RecipeIngridient: Codable {
        let ingredient: Ingredient
        let quantity: String
    }
    
    struct Step: Codable {
        let stepNumber: Int
        let description: String
        let stepImage: String?
    }
}
