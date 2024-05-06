//
//  ProfileViewModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 30/04/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var recipes: [RecipeModel]?
    @Published var profile: UserProfile?
    private var recipesRepository = RecipesRepository()
    private var profileRepository = UserProfileRepository()
    
    init(test: Bool? = false, userId: String) {
        if let testData = test, testData == true {
            self.recipes = RecipesDummyData.recipes
        } else {
            fetchUserRecipes(userId: userId)
        }
        fetchUserProfile(userId: userId)
    }
    
    func fetchUserRecipes(userId: String) {
        recipesRepository.fetchUserRecipes(userId: userId) { [weak self] recipes, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the recipes: \(error)")
                return
            } else {
                self.recipes = recipes
            }
        }
    }
    
    func fetchUserProfile(userId: String) {
        profileRepository.fetchProfile(userId: userId) { [weak self] profile, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                self.profile = profile
            }
        }
    }
}
