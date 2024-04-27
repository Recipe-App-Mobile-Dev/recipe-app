//
//  RecipesDummyData.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

class RecipesDummyData {
    public static var ToastRecipe: RecipeModel = RecipeModel(
        userId: "1",
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
    
    public static var SmoothieRecipe: RecipeModel = RecipeModel(
         userId: "1",
         recipeName: "Green Smoothie",
         imageName: "smoothie",
         recipeDescription: "A refreshing blend of banana, pineapple, and coconut water for a vibrant start to your day.",
         ingredients: [
             Ingredient(ingredientName: "Banana", imageName: "banana"): "1 whole",
             Ingredient(ingredientName: "Pineapple", imageName: "pineapple"): "1 cup",
             Ingredient(ingredientName: "Coconut water", imageName: "coconutwater"): "1 cup"
         ],
         steps: [
             RecipeModel.Step(
                 stepNumber: 1,
                 description: "Place all ingredients in a blender.",
                 stepImage: "banana"
             ),
             RecipeModel.Step(
                 stepNumber: 2,
                 description: "Blend on high until smooth.",
                 stepImage: "smoothie"
             )
         ]
     )

     public static var SaladRecipe: RecipeModel = RecipeModel(
         userId: "2",
         recipeName: "Pasta Salad",
         imageName: "pastasalad",
         recipeDescription: "A tasty pasta salad packed with cucumbers, tomatoes, and a light vinaigrette. Perfect for picnics or a quick lunch.",
         ingredients: [
             Ingredient(ingredientName: "Pasta", imageName: "pasta"): "200g",
             Ingredient(ingredientName: "Cucumbers", imageName: "cucumber"): "1 whole",
             Ingredient(ingredientName: "Tomatoes", imageName: "Tomato"): "200g",
             Ingredient(ingredientName: "Vinaigrette", imageName: "vinaigrette"): "3 tbsp"
         ],
         steps: [
             RecipeModel.Step(
                 stepNumber: 1,
                 description: "Cook the pasta according to the package directions and let it cool.",
                 stepImage: "pasta"
             ),
             RecipeModel.Step(
                 stepNumber: 2,
                 description: "Chop the cucumbers and tomatoes into bite-sized pieces.",
                 stepImage: "Tomato"
             ),
             RecipeModel.Step(
                 stepNumber: 3,
                 description: "Combine the pasta, cucumbers, tomatoes, and vinaigrette in a large bowl.",
                 stepImage: "pastasalad"
             )
         ]
     )
    
    public static var recipes: [RecipeModel] = [ToastRecipe, SmoothieRecipe, SaladRecipe]
}
