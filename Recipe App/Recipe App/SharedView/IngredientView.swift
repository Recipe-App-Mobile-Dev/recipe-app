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
    @Binding var quantity: String?
    
    init(ingredient: Ingredient, quantity: Binding<String?> = .constant(nil)) {
        self.ingredient = ingredient
        _quantity = quantity
    }
    
    var body: some View {
        HStack {
            LoadImageView(imageName: ingredient.imageName)
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
        quantity: Binding<String?> (
            get: { return "500g" },
            set: { _ in }
        )
    )
}
