//
//  RecipesDummyData.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

class RecipesDummyData {
    public static var ToastRecipe: RecipeModel = RecipeModel(
        recipeName: "Tomato Toast",
        imageName: "toasts",
        recipeDescription: "So simple. It's just toast, spread with cheese, topped with sliced fresh garden tomatoes, and sprinkled with coarse salt and freshly ground black pepper.",
        ingredients: [
            Ingredient(ingredientName: "Tomatoes", imageName: "Tomato"): "500g",
            Ingredient(ingredientName: "Bread", imageName: "bread"): "2 pieces",
            Ingredient(ingredientName: "Soft cheese", imageName: "softcheese"): "2 tsp"
        ],
        steps: [
            RecipeModel.Step(
                stepNumber: 1,
                description: "Use a toaster or toaster oven to toast the bread.",
                stepImage: "toastintheoven"
            ),
            RecipeModel.Step(
                stepNumber: 2,
                description: "While the bread is toasting, slice the tomato into 1/4-inch slices.",
                stepImage: "slicetomatoes"
            ),
            RecipeModel.Step(
                stepNumber: 3,
                description: "Once the bread is lightly toasted, spread the cheese on toasts. Top them with a couple slices of tomato, overlapping if necessary.",
                stepImage: "finish"
            )
        ]
    )
    
    //public var 
}
