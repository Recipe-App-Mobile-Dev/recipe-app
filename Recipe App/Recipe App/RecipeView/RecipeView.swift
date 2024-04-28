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
    
    init(recipe: RecipeModel, auth: AuthModel) {
        viewModel = RecipeViewModel(recipe: recipe)
        authModel = auth
    }
    
    var body: some View {
        if let fetchedRecipe = viewModel.recipe {
            GeometryReader { geometry in
                ScrollView {
                    LoadImageView(imageName: "recipes/" + fetchedRecipe.imageName)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width - 40, height: 300)
                        .cornerRadius(10)
                        .padding()
                    
                    if let recipeDescription = fetchedRecipe.recipeDescription {
                        Text(recipeDescription)
                            .foregroundColor(Color(.darkGray))
                            .padding()
                    }
                    
                    if let ingredients = fetchedRecipe.ingredients {
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
                    
                    if let steps = fetchedRecipe.steps {
                        VStack {
                            Text("Procedures")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.title2)
                                .padding(.bottom, 10.0)
                            
                            ForEach(steps.sorted(by: { $0.stepNumber < $1.stepNumber }), id: \.stepNumber) { step in
                                StepView(recipeId: fetchedRecipe.id, step: step)
                                    .padding(.bottom, 10.0)
                            }
                        }
                        .padding()
                    }

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
            ProgressView()
        }
    }
}

#Preview {
    RecipeView(recipe: RecipesDummyData.ToastRecipe, auth: AuthModel(testProfile: true))
}
