//
//  CategoryEnum.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.05.2024.
//

import Foundation

enum Category: String, CaseIterable, Identifiable, Codable, Hashable {
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
