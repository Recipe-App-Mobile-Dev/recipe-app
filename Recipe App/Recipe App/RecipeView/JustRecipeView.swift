//
//  JustRecipeView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 28.04.2024.
//

import Foundation
import SwiftUI

struct JustRecipeView: View {
    @Binding var recipe: RecipeModel
    @State var profile: UserProfile?
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    LoadImageView(imageName: recipe.imageName)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 40, height: 300)
                        .cornerRadius(10)
                        .padding()
                    
                    if let rating = recipe.rating {
                        RatingView(rating: rating)
                            .padding([.trailing, .top], 10)
                            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .topTrailing)
                    }
                }
                
                if let profile = profile {
                    ProfileCardView(profile: profile)
                }
                
                if let recipeDescription = recipe.recipeDescription {
                    Text(recipeDescription)
                        .foregroundColor(Color(.darkGray))
                        .padding()
                }
                
                
                if let categories = recipe.categories {
                    VStack {
                        ForEach(0..<categories.count/3+1) { row in
                            HStack {
                                ForEach(categories[(row * 3)..<min(row * 3 + 3, categories.count)]) { category in
                                    CategoryView(category: category)
                                }
                            }
                        }
                    }
                }
                
                if let ingredients = recipe.ingredients {
                    VStack {
                        Text("Ingredients")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .padding(.bottom, 10.0)
                        
                        ForEach(Array(ingredients), id: \.ingredient.id) { recipeIngredient in
                            IngredientView(ingredient: recipeIngredient.ingredient, quantity: recipeIngredient.quantity)
                                .padding(.vertical, 3.0)
                        }
                    }
                    .padding()
                }
                
                if let steps = recipe.steps {
                    VStack {
                        Text("Procedures")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .padding(.bottom, 10.0)
                        
                        ForEach(steps.sorted(by: { $0.stepNumber < $1.stepNumber }), id: \.stepNumber) { step in
                            StepView(recipeId: recipe.id, step: step)
                                .padding(.bottom, 10.0)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    JustRecipeView(
        recipe: Binding<RecipeModel> (
                get: { return RecipesDummyData.ToastRecipe },
                set: { _ in }
            ),
        profile: AuthModel(testProfile: true).profile
    )
}
