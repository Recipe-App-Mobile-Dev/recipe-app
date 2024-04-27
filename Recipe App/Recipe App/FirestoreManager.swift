////
////  FirestoreManager.swift
////  Recipe App
////
////  Created by Galina Abdurashitova on 26.04.2024.
////
//
//import Foundation
////import Firebase
//import FirebaseFirestore
//
//class FirestoreManager: ObservableObject {
//    @Published var restaurant: String = ""
//    private var db = Firestore.firestore()
//    
//    func fetchRecipe(id: String) -> RecipeModel? {
//        let docRef = db.collection("Recipes").document(id)
//
//        docRef.getDocument { (document, error) in
//            if let document = document {
//                if let firebaseId = document.data()?["firebaseId"] as? String,
//                   let recipeName = document.data()?["recipeName"] as? String,
//                   let imageName = document.data()?["imageName"] as? String,
//                   let recipeDescription = document.data()?["imageName"] as? String
//                    //let ingredients = document.data()?["ingredients"] as? String
//                {
//                    let recipe = RecipeModel(
//                        userId: "1",
//                        recipeName: recipeName,
//                        imageName: imageName,
//                        recipeDescription: recipeDescription,
//                        ingredients: [
//                            Ingredient(ingredientName: "Tomatoes", imageName: "Tomato"): "500g",
//                            Ingredient(ingredientName: "Bread", imageName: "bread"): "2 pieces",
//                            Ingredient(ingredientName: "Soft cheese", imageName: "softcheese"): "2 tsp"
//                        ],
//                        steps: [
//                            RecipeModel.Step(
//                                stepNumber: 1,
//                                description: "Use a toaster or toaster oven to toast the bread.",
//                                stepImage: "toastintheoven"
//                            ),
//                            RecipeModel.Step(
//                                stepNumber: 2,
//                                description: "While the bread is toasting, slice the tomato into 1/4-inch slices.",
//                                stepImage: "slicetomatoes"
//                            ),
//                            RecipeModel.Step(
//                                stepNumber: 3,
//                                description: "Once the bread is lightly toasted, spread the cheese on toasts. Top them with a couple slices of tomato, overlapping if necessary.",
//                                stepImage: "finish"
//                            )
//                        ]
//                    )
//                    return //recipe
//                }
//
//            }
//        }
//        return nil
//    }
//}
