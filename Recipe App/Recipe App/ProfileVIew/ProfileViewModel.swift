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
    @Published var isRefreshing = false
    private var recipesRepository = RecipesRepository()
    private var profileRepository = UserProfileRepository()
    
    init(test: Bool? = false, userId: String) {
        if let testData = test, testData == true {
            self.recipes = RecipesDummyData.recipes
        } else {
            Task {
                await fetchUserRecipes(userId: userId)
            }
        }
        fetchUserProfile(userId: userId)
    }
    
    func fetchUserRecipes(userId: String) async {
        recipesRepository.fetchUserRecipes(userId: userId) { [weak self] recipes, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the recipes: \(error)")
                return
            } else {
                DispatchQueue.main.async {
                    self.recipes = recipes
                    self.isRefreshing = false
                }
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
