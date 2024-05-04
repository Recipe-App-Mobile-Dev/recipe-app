//
//  EditRecipeView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 04.05.2024.
//

import Foundation
import SwiftUI

struct EditRecipeView: View {
    @State var editingRecipe: RecipeModel
    @State var description: String
    @State var ingredients: [RecipeModel.RecipeIngridient]
    
    init(recipe: RecipeModel) {
        self.editingRecipe = recipe
        self.description = recipe.recipeDescription ?? ""
        if let ingredients = recipe.ingredients {
            print(ingredients)
            self.ingredients = ingredients
            print(self.ingredients)
        } else {
            self.ingredients = []
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LoadImageView(imageName: "recipes/" + editingRecipe.imageName)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 40, height: 300)
                    .cornerRadius(10)
                    .padding()
                
                TextField("Enter description", text: $description, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(Color(.darkGray))
                    .padding()
                
                VStack {
                    Text("Ingredients")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .padding(.bottom, 10.0)
                    
                    ForEach($ingredients, id: \.ingredient.id) { $recipeIngredient in
                        HStack {
                            Button(action: {
                                ingredients = ingredients.filter() {$0 != recipeIngredient}
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color.red)
                            }
                            IngredientView(ingredient: recipeIngredient.ingredient)
                            Spacer()
                            TextField("Quantity", text: $recipeIngredient.quantity, axis: .vertical)
                                .frame(width: geometry.size.width * 0.3)
                                .textFieldStyle(.roundedBorder)
                                .foregroundColor(Color(.darkGray))
                        }
                        .padding(.vertical, 3.0)
                    }
                }
                .padding()
                
                if let steps = editingRecipe.steps {
                    VStack {
                        Text("Procedures")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .padding(.bottom, 10.0)
                        
                        ForEach(steps.sorted(by: { $0.stepNumber < $1.stepNumber }), id: \.stepNumber) { step in
                            StepView(recipeId: editingRecipe.id, step: step)
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
    EditRecipeView(recipe: RecipesDummyData.ToastRecipe)
}
