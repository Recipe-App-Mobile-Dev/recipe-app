//
//  IngridientModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

struct Ingredient: Identifiable, Hashable, Codable {
    let id = UUID()
    let ingredientName: String
    let imageName: String
}
