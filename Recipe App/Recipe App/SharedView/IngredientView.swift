//
//  IngridientView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation
import SwiftUI

struct IngredientView: View {
    @State var ingredient: Ingredient
    @State var quantity: String?
    
    var body: some View {
        HStack {
            LoadImageView(imageName: "ingredients/" + ingredient.imageName)
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(10)
            
            Text(ingredient.ingredientName)
            
            if let quantity = self.quantity {
                Spacer()
                Text(quantity)
            }
        }
    }
}

#Preview {
    IngredientView(
        ingredient: Ingredient(id: "1", ingredientName: "tomatoes", imageName: "Tomato"),
        quantity: "500g"
    )
}