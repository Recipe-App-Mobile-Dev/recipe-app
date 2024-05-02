//
//  RecipeModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

enum Category: String, CaseIterable, Identifiable, Codable{
    var id: String { self.rawValue }
    
    case breakfast = "Breakfast"
    case soup = "Soup"
    case salad = "Salad"
    case appetizer = "Appetizer"
    case main = "Main"
    case side = "Side"
    case dessert = "Dessert"
    case snack = "Snack"
    case drink = "Drink"
}

struct RecipeModel: Identifiable, Codable {
    var id: String
    var userId: String
    var recipeName: String
    var imageName: String
    var recipeDescription: String?
    var ingredients: [RecipeIngridient]? = nil
    var steps: [Step]? = nil
    var categories: [Category] = []
    
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
