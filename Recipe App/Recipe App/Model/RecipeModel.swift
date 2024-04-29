//
//  RecipeModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

struct RecipeModel: Identifiable, Codable {
    var id: String
    var userId: String
    var recipeName: String
    var imageName: String
    var recipeDescription: String?
    var ingredients: [RecipeIngridient]? = nil
    var steps: [Step]? = nil
    
    struct RecipeIngridient: Codable {
        var ingredient: Ingredient
        var quantity: String
    }
    
    struct Step: Codable {
        var stepNumber: Int
        var description: String
        var stepImage: String?
    }
}
