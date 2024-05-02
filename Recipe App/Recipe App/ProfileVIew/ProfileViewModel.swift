//
//  ProfileViewModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 30/04/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var recipes: [RecipeModel]?
    private var recipesRepository = RecipesRepository()
    
    init(test: Bool? = false, userId: String) {
        if let testData = test, testData == true {
            self.recipes = RecipesDummyData.recipes
        } else {
            fetchUserRecipes(userId: userId)
        }
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
}
