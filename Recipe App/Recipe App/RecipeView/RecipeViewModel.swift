//
//  RecipeViewModel.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    @ObservedObject var authModel: AuthModel
    @Published var recipe: RecipeModel?
    @Published var isDeleted: Bool = false
    @Published var isEditing: Bool = false
    @Published var userRating: Int?
    @Published var isRated: Int = 0
    @Published var deletionAlert: Bool = false
    @Published var ratingAlert: Bool = false
    private var recipesRepository = RecipesRepository()
    
    
    init(recipe: RecipeModel, auth: AuthModel) {
        self.authModel = auth
        fetchRecipe(recipe: recipe)
    }
    
    
    func fetchRecipe(recipe: RecipeModel) {
        recipesRepository.fetchRecipeInfo(forRecipe: recipe) { [weak self] recipe, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the recipe: \(error)")
                return
            } else {
                self.recipe = recipe
            }
        }
    }

    
    func deleteRecipe(completion: @escaping () -> Void) {
        if let id = recipe?.id {
            recipesRepository.deleteRecipe(recipeId: id) { error in
                if let error = error {
                    print("Error deleting recipe: \(error.localizedDescription)")
                } else {
                    self.isDeleted = true
                    completion()
                }
            }
        }
    }
    
    func rateRecipe() {
        if let id = recipe?.id, let rating = userRating {
            recipesRepository.addRecipeRating(stars: rating, recipeId: id, userId: authModel.profile.uid) { error in
                DispatchQueue.main.async {
                    self.isRated = rating
                }
            }
        }
    }
    
    func getUsersRating() {
        if let id = recipe?.id {
            recipesRepository.fetchUsersRecipeRating(recipeId: id, userId: authModel.profile.uid) { rating, error in
                DispatchQueue.main.async {
                    if let rating = rating {
                        self.userRating = rating
                        self.isRated = rating
                    }
                }
            }
        }
    }
    
    // func editRecipe
}
