//
//  RecipesViewModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 16/04/2024.
//

import Foundation

class RecipesViewModel: ObservableObject {
    @Published var recipes: [RecipeModel]?
    private var recipesRepository = RecipesRepository()
    
    init(test: Bool? = false) {
        if let testData = test, testData == true {
            self.recipes = RecipesDummyData.recipes
        } else {
            fetchRecipes()
            print("Logged in")
        }
    }
    
    func fetchRecipes() {
        recipesRepository.fetchRecipes() { [weak self] recipes, error in
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

