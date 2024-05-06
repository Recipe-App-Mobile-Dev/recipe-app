//
//  RecipeCardView.swift
//  Recipe App
//
//  Created by Jin Mizuno on 16/04/2024.
//

import Foundation
import SwiftUI

struct RecipeCardView: View {
    var recipe: RecipeModel
    
    var body: some View {
        ZStack {
            LoadImageView(imageName: "recipes/" + recipe.imageName)
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 5)
                .overlay(
                    Text(recipe.recipeName)
                        .font(.title)
                        .bold()
                        .padding(10)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(5),
                    alignment: .bottomTrailing
                )
                .overlay(
                    Group {
                        if let rating = recipe.rating {
                            RatingView(rating: rating)
                                .padding([.trailing, .top], 10)
                        }
                    },
                    alignment: .topTrailing
                )
        }
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        var recipe = RecipesDummyData.ToastRecipe
        RecipeCardView(recipe: recipe)
    }
}
