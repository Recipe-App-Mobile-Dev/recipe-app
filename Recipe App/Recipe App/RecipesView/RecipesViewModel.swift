//
//  RecipesViewModel.swift
//  Recipe App
//
//  Created by Jin Mizuno on 16/04/2024.
//

import Foundation

class RecipesViewModel: ObservableObject {
    @Published var recipes: [RecipeModel]?
    @Published var isRefreshing = false
    private var recipesRepository = RecipesRepository()
    
    init(test: Bool? = false) {
        if let testData = test, testData == true {
            self.recipes = RecipesDummyData.recipes
        } else {
            print("Logged in")
            Task {
                await fetchRecipes()
            }
        }
    }
    
    func fetchRecipes() async {
        recipesRepository.fetchRecipes() { [weak self] recipes, error in
            guard let self = self else { return }
            if let error = error {
                print("Error while fetching the recipes: \(error)")
                self.isRefreshing = false
                return
            } else {
                DispatchQueue.main.async {
                    self.recipes = recipes
                    self.isRefreshing = false
                }
            }
        }
    }
}

