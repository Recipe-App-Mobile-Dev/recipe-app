//
//  RecipeView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.04.2024.
//

import Foundation
import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    @ObservedObject var authModel: AuthModel
    
    init(recipeId: String, auth: AuthModel) {
        viewModel = RecipeViewModel(recipeId: recipeId)
        authModel = auth
    }
    
    var body: some View {
        if let fetchedRecipe = viewModel.recipe {
            GeometryReader { geometry in
                ScrollView {
                    Image(fetchedRecipe.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 40, height: 300)
                        .cornerRadius(10)
                        .padding()
                    
                    if let recipeDescription = fetchedRecipe.recipeDescription {
                        Text(recipeDescription)
                            .foregroundColor(Color(.darkGray))
                            .padding()
                    }
                    
                    VStack {
                        Text("Ingredients")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .padding(.bottom, 10.0)
                        
                        ForEach(Array(fetchedRecipe.ingredients), id: \.ingredient.id) { recipeIngredient in
                            IngredientView(ingredient: recipeIngredient.ingredient, quantity: recipeIngredient.quantity)
                                .padding(.vertical, 3.0)
                        }
                    }
                    .padding()
                    
                    VStack {
                        Text("Procedures")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .padding(.bottom, 10.0)
                        
                        ForEach(fetchedRecipe.steps, id: \.stepNumber) { step in
                            StepView(step: step)
                                .padding(.bottom, 10.0)
                        }
                    }
                    .padding()

                    if let userId = authModel.profile?.uid,
                       userId == fetchedRecipe.userId {
                        HStack {
                            ButtonView(text: "Edit", color: Color.green)
                                .padding(.horizontal, 5.0)
                            ButtonView(text: "Delete", color: Color.red)
                                .padding(.horizontal, 5.0)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(fetchedRecipe.recipeName)
        } else {
            Label("Loading", systemImage: "hourglass")
        }
    }
}

#Preview {
    RecipeView(recipeId: "8t4KSPZAvzclXoCzBpOQZifge0m2", auth: AuthModel())
}
