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
        GeometryReader { geometry in
            ScrollView {
                Image(viewModel.recipe.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 40, height: 300)
                    .cornerRadius(10)
                    .padding()
                
                if let recipeDescription = viewModel.recipe.recipeDescription {
                    Text(recipeDescription)
                        .foregroundColor(Color(.darkGray))
                        .padding()
                }
                
                VStack {
                    Text("Ingredients")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .padding(.bottom, 10.0)
                    
                    ForEach(Array(viewModel.recipe.ingredients), id: \.key.id) { ingredient, quantity in
                        IngredientView(ingredient: ingredient, quantity: quantity)
                            .padding(.vertical, 3.0)
                    }
                }
                .padding()
                
                VStack {
                    Text("Procedures")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .padding(.bottom, 10.0)
                    
                    ForEach(viewModel.recipe.steps, id: \.stepNumber) { step in
                        StepView(step: step)
                            .padding(.bottom, 10.0)
                    }
                }
                .padding()

                if let userId = authModel.profile?.uid,
                   userId == viewModel.recipe.userId {
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
        .navigationTitle(viewModel.recipe.recipeName)
    }
}

#Preview {
    RecipeView(recipe: RecipesDummyData.ToastRecipe, auth: AuthModel())
}
