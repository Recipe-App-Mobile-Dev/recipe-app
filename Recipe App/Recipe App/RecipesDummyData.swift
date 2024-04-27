//
//  RecipesDummyData.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation

class RecipesDummyData {
    public static var ToastRecipe: RecipeModel = RecipeModel(
        id: "kIBFyJd7Rotf5bXJt18A",
        userId: "8t4KSPZAvzclXoCzBpOQZifge0m2",
        recipeName: "Tomato Toast",
        imageName: "toasts",
        recipeDescription: "So simple. It's just toast, spread with cheese, topped with sliced fresh garden tomatoes, and sprinkled with coarse salt and freshly ground black pepper.",
        ingredients: [
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Tomatoes", imageName: "Tomato"),
                quantity: "500g"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Bread", imageName: "bread"),
                quantity: "2 pieces"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Soft cheese", imageName: "softcheese"),
                quantity: "2 tsp"
            )
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
         id: "kIBFyJd7Rotf5bXJt18A",
         userId: "X0TPP4gkuPQCbPvnxE6GZXy4gh02",
         recipeName: "Green Smoothie",
         imageName: "smoothie",
         recipeDescription: "A refreshing blend of banana, pineapple, and coconut water for a vibrant start to your day.",
         ingredients: [
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Banana", imageName: "banana"),
                quantity: "1 whole"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Pineapple", imageName: "pineapple"),
                quantity: "1 cup"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Coconut water", imageName: "coconutwater"),
                quantity: "1 cup"
            )
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
         id: "kIBFyJd7Rotf5bXJt18A",
         userId: "CZpkmBv7HqNpisSOMo6VLqiP0Us2",
         recipeName: "Pasta Salad",
         imageName: "pastasalad",
         recipeDescription: "A tasty pasta salad packed with cucumbers, tomatoes, and a light vinaigrette. Perfect for picnics or a quick lunch.",
         ingredients: [
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Pasta", imageName: "pasta"),
                quantity: "200g"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Cucumbers", imageName: "cucumber"),
                quantity: "1 whole"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Tomatoes", imageName: "Tomato"),
                quantity: "200g"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(ingredientName: "Vinaigrette", imageName: "vinaigrette"),
                quantity: "3 tbsp"
            )
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
