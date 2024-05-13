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
    @Binding var isRefreshing: Bool
    @State var profile: UserProfile?
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    LoadImageView(imageName: recipe.imageName, reloadTrigger: isRefreshing)
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
                        
                        ForEach(ingredients, id: \.self) { recipeIngredient in
                            IngredientView(ingredient: recipeIngredient.ingredient, quantity: .constant(recipeIngredient.quantity))
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
                            StepView(recipeId: recipe.id, step: .constant(step), isRefreshing: $isRefreshing)
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
        isRefreshing: Binding<Bool> (
            get: { return false },
            set: { _ in }
        ),
        profile: AuthModel(testProfile: true).profile
    )
}
