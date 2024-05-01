//
//  SearchModel.swift
//  Recipe App
//
//  Created by Reza on 1/5/24.
//

import Foundation
import SwiftUI

class SearchModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedTimeFilter = "All"
    @Published var selectedRatingFilter = "All"
    @Published var selectedCategoryFilter = "All"
    
    // Dummy data for demonstration
    var recipes = [
        Recipe(name: "Pasta Carbonara", category: "Italian", rating: 5, time: "30 mins"),
        Recipe(name: "Chicken Curry", category: "Dinner", rating: 4, time: "45 mins"),
        Recipe(name: "Greek Salad", category: "Vegetables", rating: 5, time: "15 mins"),
        Recipe(name: "French Toast", category: "Breakfast", rating: 4, time: "20 mins"),
        Recipe(name: "Sushi Rolls", category: "Japanese", rating: 5, time: "40 mins"),
    ]
    
    func filterRecipes() -> [Recipe] {
        var filteredRecipes = recipes
        
        if !searchText.isEmpty {
            filteredRecipes = filteredRecipes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        if selectedTimeFilter != "All" {
            filteredRecipes = filteredRecipes.filter { $0.time == selectedTimeFilter }
        }
        
        if selectedRatingFilter != "All" {
            let rating = Int(selectedRatingFilter)!
            filteredRecipes = filteredRecipes.filter { $0.rating == rating }
        }
        
        if selectedCategoryFilter != "All" {
            filteredRecipes = filteredRecipes.filter { $0.category == selectedCategoryFilter }
        }
        
        return filteredRecipes
    }
}
