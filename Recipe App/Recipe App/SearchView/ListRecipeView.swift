//
//  ListRecipeView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.05.2024.
//

import Foundation
import SwiftUI

struct ListRecipeView: View {
    @State var recipe: RecipeModel
    
    var body: some View {
        HStack {
            LoadImageView(imageName: recipe.imageName)
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(recipe.recipeName)
                    .font(.headline)
                if let description = recipe.recipeDescription {
                    Text(description)
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding(.horizontal, 5.0)
            
            Spacer()
            if let rating = recipe.rating {
                Label(String(format: "%.1f", rating), systemImage:"star.fill")
                    .foregroundColor(Color(red: 0.8, green: 0.6, blue: 0.0))
                    .fontWeight(.medium)
            }
        }
    }
}

#Preview {
    ListRecipeView(
        recipe: RecipesDummyData.ToastRecipe
    )
}
