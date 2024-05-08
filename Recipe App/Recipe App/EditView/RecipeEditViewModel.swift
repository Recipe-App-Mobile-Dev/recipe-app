//
//  RecipeEditViewModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 07.05.2024.
//

import Foundation
import SwiftUI

class RecipeEditViewModel: ObservableObject {
    @Binding var editingRecipe: RecipeModel
    @Published var editingRecipeId: String
    @Published var editingMainImageName: String
    @Published var editingMainImage: UIImage?
    @Published var editingDescription: String
    @Published var editingIngredients: [RecipeModel.RecipeIngridient]
    @Published var editingSteps: [RecipeModel.Step]
    @Published var editingStepImages: [UIImage?] = []
    private var recipesRepository = RecipesRepository()
    private var imagesRepository = ImagesRepository()
    
    init(recipe: Binding<RecipeModel>) {
        _editingRecipe = recipe
        self.editingRecipeId = recipe.id.wrappedValue
        self.editingMainImageName = recipe.imageName.wrappedValue
        self.editingDescription = recipe.recipeDescription.wrappedValue ?? ""
        if let ingredients = recipe.ingredients.wrappedValue {
            self.editingIngredients = ingredients
        } else {
            self.editingIngredients = []
        }
        if let steps = recipe.steps.wrappedValue {
            self.editingSteps = steps.sorted(by: { $0.stepNumber < $1.stepNumber })
            for _ in steps {
                editingStepImages.append(nil)
            }
        } else {
            self.editingSteps = []
        }
    }
    
    func saveChanges(completion: @escaping (_ done: Bool, _ message: String?) -> Void) {
        guard self.editingSteps.count > 0, self.editingSteps.allSatisfy({ !$0.description.isEmpty }),
              self.editingIngredients.count > 0, self.editingIngredients.allSatisfy({ !$0.quantity.isEmpty }) else {
            completion(false, "Please check you filled in all fields")
            return
        }

        self.uploadImages() { done, error in
            if !done {
                completion(false, error)
                return
            }

            let updatedRecipe = RecipeModel(
                id: self.editingRecipeId,
                userId: self.editingRecipe.userId,
                recipeName: self.editingRecipe.recipeName,
                imageName: self.editingMainImageName,
                recipeDescription: self.editingDescription,
                ingredients: self.editingIngredients,
                steps: self.editingSteps,
                categories: self.editingRecipe.categories,
                dateCreated: self.editingRecipe.dateCreated,
                rating: self.editingRecipe.rating
            )

            self.recipesRepository.updateRecipe(recipeId: self.editingRecipeId, recipe: updatedRecipe) { done, error in
                if done {
                    completion(true, nil)
                } else {
                    completion(false, "Recipe updating error")
                }
            }
        }
    }
    
    func uploadImages(completion: @escaping (_ done: Bool, _ message: String?) -> Void) {
        let dispatchGroup = DispatchGroup()
        if let image = editingMainImage {
            dispatchGroup.enter()
            imagesRepository.uploadImage(folder: "recipes", image: image) { imageURL in
                defer {
                    dispatchGroup.leave()
                }
                guard let imageURL = imageURL else {
                    completion(false, "Main image cannot be saved")
                    return
                }
                
                self.editingMainImageName = imageURL
            }
        }
        
        for i in 0..<editingStepImages.count {
            if let image = editingStepImages[i] {
                dispatchGroup.enter()
                imagesRepository.uploadImage(folder: "recipesteps/\(editingRecipeId)", image: image) { imageURL in
                    defer {
                        dispatchGroup.leave()
                    }
                    guard let imageURL = imageURL else {
                        completion(false, "Image for step \(i+1) cannot be saved")
                        return
                    }
                    
                    self.editingSteps[i].stepImage = imageURL
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(true, nil)
        }
    }
    
    func reloadRecipe(recipe: RecipeModel) {
        recipesRepository.reloadRecipe(recipeId: recipe.id) { [weak self] recipe, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the recipe: \(error)")
                return
            } else {
                DispatchQueue.main.async {
                    self.editingRecipe = recipe!
                }
            }
        }
    }
    
    func recalculateSteps() {
        for i in 0..<editingSteps.count {
            editingSteps[i].stepNumber = i+1
        }
    }
}
