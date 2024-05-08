//
//  RecipeModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation
import SwiftUI

struct RecipeModel: Identifiable, Codable, Hashable {
    var id: String
    var userId: String
    var recipeName: String
    var imageName: String
    var recipeDescription: String?
    var ingredients: [RecipeIngridient]? = nil
    var steps: [Step]? = nil
    var categories: [Category]?
    var dateCreated: Date
    var rating: Double?
    
    struct RecipeIngridient: Codable, Hashable {
        var ingredient: Ingredient
        var quantity: String
    }
    
    struct Step: Codable, Hashable {
        var stepNumber: Int
        var description: String
        var stepImage: String?
    }
}

struct NewRecipeModel {
    var userId: String
    var recipeName: String
    var imageName: UIImage?
    var recipeDescription: String
    var ingredients: [RecipeModel.RecipeIngridient]? = nil
    var steps: [RecipeModel.Step]? = nil
    var categories: [Category]?
}
