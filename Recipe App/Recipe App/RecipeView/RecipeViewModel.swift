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
    @Published var userProfile: UserProfile?
    @Published var isDeleted: Bool = false
    @Published var isEditing: Bool = false
    @Published var userRating: Int?
    @Published var isRated: Int = 0
    @Published var deletionAlert: Bool = false
    @Published var ratingAlert: Bool = false
    @Published var isRefreshing = false
    
    private var recipesRepository = RecipesRepository()
    private var usersRepository = UserProfileRepository()
    
    
    init(recipe: RecipeModel, auth: AuthModel) {
        self.authModel = auth
        fetchRecipe(recipe: recipe)
        fetchUser(user: recipe.userId)
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
    
    
    func reloadRecipe() async {
        guard let recipe = self.recipe else {
            return
        }
        recipesRepository.reloadRecipe(recipeId: recipe.id) { [weak self] recipe, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the recipe: \(error)")
                self.isRefreshing = false
                return
            } else {
                DispatchQueue.main.async {
                    self.recipe = recipe
                    self.isRefreshing = false
                }
            }
        }
    }
    
    
    func fetchUser(user: String) {
        usersRepository.fetchProfile(userId: user) { (profile, error) in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            }
            
            if let profile = profile {
                self.userProfile = profile
            } else {
                print("Error: User profile not found.")
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
    
}
