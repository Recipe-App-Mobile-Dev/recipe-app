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
            JustRecipeView(recipe: fetchedRecipe)
                .navigationTitle(fetchedRecipe.recipeName)

            if authModel.profile.uid == fetchedRecipe.userId {
                HStack {
                    Button(action: RecipesDummyData.addDataToFirebase) {
                        ButtonView(text: "Edit", color: Color.green)
                    }
                    .padding(.horizontal, 5.0)
                    
                    
                    Button(action:  {
                        viewModel.deleteRecipe() {
                            
                        }
                    }) {
                        ButtonView(text: "Delete", color: Color.red)
                    }
                    .padding(.horizontal, 5.0)
                }
                .padding()
            }
        } else {
            ProgressView()
        }

    }
}

#Preview {
    RecipeView(recipe: RecipesDummyData.ToastRecipe, auth: AuthModel(testProfile: true))
}
