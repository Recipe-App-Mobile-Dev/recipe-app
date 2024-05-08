//
//  IngridientModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation
import SwiftUI
import UIKit

struct Ingredient: Hashable, Codable {
    var id: String?
    var ingredientName: String
    var imageName: String
}
