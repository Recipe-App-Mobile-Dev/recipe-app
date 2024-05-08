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
    @Published var newSteps: [RecipeModel.Step] = []
    @Published var newStepImages: [UIImage?] = []
    @Published var selectedCategories: [Category] = []
    @Published var newIngredients: [RecipeModel.RecipeIngridient] = []
    var onSaveCompleted: (() -> Void)?
    
    init(auth: AuthModel) {
        self.authModel = auth
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
            steps: newSteps,
            categories: selectedCategories
        )
        
        rep.addRecipe(recipe: newRecipe, newStepImages: newStepImages) { (ingredient, error) in
           if let error = error {
               print("Error while adding a new recipe: \(error)")
               return
           }
           DispatchQueue.main.async {
               self.onSaveCompleted?()
           }
       }
    }
    
    func recalculateSteps() {
        for i in 0..<newSteps.count {
            newSteps[i].stepNumber = i+1
        }
    }
}
