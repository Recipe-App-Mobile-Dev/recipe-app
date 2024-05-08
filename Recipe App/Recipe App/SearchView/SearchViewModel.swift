//
//  SearchModel.swift
//  Recipe App
//
//  Created by Reza on 1/5/24.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var recipes: [RecipeModel]
    @Published var searchText = ""
    @Published var selectedTimeFilter = "All"
    @Published var selectedRatingFilter = "All"
    @Published var selectedCategoryFilter: Category? = nil 
    
    init(recipes:  [RecipeModel]) {
        self.recipes = recipes
    }
    
    func filterRecipes() -> [RecipeModel]? {
        var filteredRecipes = recipes
        
        if !searchText.isEmpty {
            filteredRecipes = filteredRecipes.filter { $0.recipeName.lowercased().contains(searchText.lowercased()) }
        }
        
        if selectedTimeFilter != "All" {
            switch(selectedTimeFilter) {
            case "Newest":
                filteredRecipes = filteredRecipes.sorted { $0.dateCreated >= $1.dateCreated }
            case "Oldest":
                filteredRecipes = filteredRecipes.sorted { $0.dateCreated <= $1.dateCreated }
            case "Popularity":
                filteredRecipes = filteredRecipes
                    .filter { $0.rating != nil }
                    .sorted { $0.rating! >= $1.rating! }
            default:
                break
            }
        }
        
        if selectedRatingFilter != "All" {
            let rating = Int(selectedRatingFilter)!
            filteredRecipes = filteredRecipes.filter {
                if let recipeRating = $0.rating {
                    return recipeRating >= Double(rating)
                }
                return false
            }
        }
        
        if let selectedCategory = selectedCategoryFilter {
            filteredRecipes = filteredRecipes.filter {
                if let categories =  $0.categories {
                    return categories.contains(selectedCategory)
                }
                return false
            }
        }
        
        if filteredRecipes.count == 0 {
            return nil
        }
        return filteredRecipes
    }
}
