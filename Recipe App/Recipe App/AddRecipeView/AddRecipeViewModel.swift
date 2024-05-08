//
//  AddRecipeViewModel.swift
//  Recipe App
//
//  Created by 吴金泳 on 05/05/2024.
//

import Foundation
import SwiftUI
import UIKit

struct IngredientData {
    var image: UIImage?
    var ingredient: String
    var quantity: String
}

class AddRecipeViewModel: ObservableObject {
    @ObservedObject var authModel: AuthModel
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var image: UIImage?
    @Published var isShowingImagePicker = false
    @Published var isShowingImagePicker2 = false
    @Published var selectedIngredientIndex = 0
    @Published var procedures: [String] = []
    @Published var selectedCategories: [Category] = []
    @Published var newIngredients: [RecipeModel.RecipeIngridient] = []
    var onSaveCompleted: (() -> Void)?
    
    init(auth: AuthModel) {
        self.authModel = auth
    }
    
    func addProcedure() {
        procedures.append("")
    }
    
    func toggleCategorySelection(_ category: Category){
        if selectedCategories.contains(category) {
            selectedCategories.removeAll{ $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }
    
    func saveRecipe() {
        let rep = RecipesRepository()
        
        let newRecipe = NewRecipeModel(
            userId: authModel.profile.uid,
            recipeName: name,
            imageName: image,
            recipeDescription: description,
            ingredients: newIngredients,
            steps: procedures.enumerated().map { index, stepDescription in
                NewRecipeModel.Step(stepNumber: index + 1, description: stepDescription)
            },
            categories: selectedCategories
        )
        
        rep.addRecipe(recipe: newRecipe) { (ingredient, error) in
            if let error = error {
                print("Error while adding a new recipe: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.onSaveCompleted?()
            }
        }
    }
}
