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
        imageName: "toasts.jpg",
        recipeDescription: "So simple. It's just toast, spread with cheese, topped with sliced fresh garden tomatoes, and sprinkled with coarse salt and freshly ground black pepper.",
        ingredients: [
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "TK64liqxdDmlkODMrtOP", ingredientName: "Tomatoes", imageName: "Tomato.jpeg"),
                quantity: "500g"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "8s4sJgwMfjRF1fQGeeNt", ingredientName: "Bread", imageName: "bread.jpg"),
                quantity: "2 pieces"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "e3WTv0Q7ou3jdyI1Ykgn", ingredientName: "Soft cheese", imageName: "softcheese.jpeg"),
                quantity: "2 tsp"
            )
        ],
        steps: [
            RecipeModel.Step(
                stepNumber: 1,
                description: "Use a toaster or toaster oven to toast the bread.",
                stepImage: "toastintheoven.jpg"
            ),
            RecipeModel.Step(
                stepNumber: 2,
                description: "While the bread is toasting, slice the tomato into 1/4-inch slices.",
                stepImage: "slicetomatoes.jpeg"
            ),
            RecipeModel.Step(
                stepNumber: 3,
                description: "Once the bread is lightly toasted, spread the cheese on toasts. Top them with a couple slices of tomato, overlapping if necessary.",
                stepImage: "finish.jpeg"
            )
        ],
        categories: [.breakfast, .appetizer],
        dateCreated: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1, hour: 12, minute: 0))!,
        rating: 4.92304
    )
    
    public static var SmoothieRecipe: RecipeModel = RecipeModel(
         id: "LjxL6YXqysgGoiO0BtII",
         userId: "8t4KSPZAvzclXoCzBpOQZifge0m2",
         recipeName: "Green Smoothie _ delete later",
         imageName: "smoothie.jpeg",
         recipeDescription: "A refreshing blend of banana, pineapple, and coconut water for a vibrant start to your day.",
         ingredients: [
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "64DcyApmUJtAUWlajdzh", ingredientName: "Banana", imageName: "banana.jpeg"),
                quantity: "1 whole"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "127ueNcgsjfzXwIAnD4r", ingredientName: "Pineapple", imageName: "pineapple.jpeg"),
                quantity: "1 cup"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "VF6s6A6uvCqNxMxK94iL", ingredientName: "Coconut water", imageName: "coconutwater.jpeg"),
                quantity: "1 cup"
            )
         ],
         steps: [
             RecipeModel.Step(
                 stepNumber: 1,
                 description: "Place all ingredients in a blender.",
                 stepImage: "banana.jpeg"
             ),
             RecipeModel.Step(
                 stepNumber: 2,
                 description: "Blend on high until smooth.",
                 stepImage: "smoothie.jpeg"
             )
         ],
         categories: [.drink],
         dateCreated: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 2, hour: 12, minute: 0))!,
         rating: 4.2340
     )

     public static var SaladRecipe: RecipeModel = RecipeModel(
         id: "Ul4yz7gmnE5Ag9mDb1NW",
         userId: "CZpkmBv7HqNpisSOMo6VLqiP0Us2",
         recipeName: "Pasta Salad",
         imageName: "pastasalad.jpeg",
         recipeDescription: "A tasty pasta salad packed with cucumbers, tomatoes, and a light vinaigrette. Perfect for picnics or a quick lunch.",
         ingredients: [
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "c9P3VhY5wfRgiUa3RLYq", ingredientName: "Pasta", imageName: "pasta.jpeg"),
                quantity: "200g"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "JGMCQzXdLgo3U91nr0LX", ingredientName: "Cucumbers", imageName: "cucumber.jpeg"),
                quantity: "1 whole"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "TK64liqxdDmlkODMrtOP", ingredientName: "Tomatoes", imageName: "Tomato.jpeg"),
                quantity: "200g"
            ),
            RecipeModel.RecipeIngridient(
                ingredient: Ingredient(id: "QuBBGxlPDCNWEeIkoLvU", ingredientName: "Vinaigrette", imageName: "vinaigrette.jpeg"),
                quantity: "3 tbsp"
            )
         ],
         steps: [
             RecipeModel.Step(
                 stepNumber: 1,
                 description: "Cook the pasta according to the package directions and let it cool.",
                 stepImage: "pasta.jpeg"
             ),
             RecipeModel.Step(
                 stepNumber: 2,
                 description: "Chop the cucumbers and tomatoes into bite-sized pieces.",
                 stepImage: "Tomato.jpeg"
             ),
             RecipeModel.Step(
                 stepNumber: 3,
                 description: "Combine the pasta, cucumbers, tomatoes, and vinaigrette in a large bowl.",
                 stepImage: "pastasalad.jpeg"
             )
         ],
         categories: [.breakfast, .salad, .side],
         dateCreated: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3, hour: 12, minute: 0))!
     )
    
    public static var recipes: [RecipeModel] = [ToastRecipe, SmoothieRecipe, SaladRecipe]
    
    static func addDataToFirebase() {
        var rep = RecipesRepository()
        
//        var ingredients = [
//            Ingredient(id: "4", ingredientName: "Banana", imageName: "banana.jpeg"),
//            Ingredient(id: "5", ingredientName: "Pineapple", imageName: "pineapple.jpeg"),
//            Ingredient(id: "6", ingredientName: "Coconut water", imageName: "coconutwater.jpeg"),
//            Ingredient(id: "7", ingredientName: "Pasta", imageName: "pasta.jpeg"),
//            Ingredient(id: "8", ingredientName: "Cucumbers", imageName: "cucumber.jpeg"),
//            Ingredient(id: "9", ingredientName: "Vinaigrette", imageName: "vinaigrette.jpeg")
//        ]
//        
//        for ingredient in ingredients {
//            rep.addIngredient(ingredient: ingredient) { (ingredient, error) in
//                if let error = error {
//                    print("Error while fetching the user profile: \(error)")
//                    return
//                }
//            }
//        }
        
        rep.addRecipe(recipe: SmoothieRecipe) { (ingredient, error) in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            }
        }

    }
}
