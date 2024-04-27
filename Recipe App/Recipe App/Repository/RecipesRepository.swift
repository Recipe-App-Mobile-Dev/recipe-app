//
//  RecipesRepository.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 26.04.2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class RecipesRepository: ObservableObject {
    private var db = Firestore.firestore()
    
    
    func fetchRecipe(id: String, completion: @escaping (_ recipe: RecipeModel?, _ error: Error?) -> Void) {
        db.collection("recipes").document(id).getDocument { (document, error) in
            guard error == nil else {
                print("error getting recipe", error ?? "")
                return
            }
            
            if let data = document?.data() {
                
                let dispatchGroup = DispatchGroup() // Create a DispatchGroup to wait for all asynchronous calls
                var steps: [RecipeModel.Step]? = []
                
                dispatchGroup.enter() // Enter the DispatchGroup before making an asynchronous call
                self.fetchSteps(recipeId: id) { (recipeSteps, error) in
                    defer {
                        dispatchGroup.leave() // Leave the DispatchGroup after the asynchronous call completes
                    }
                    
                    if let error = error {
                        print("Error while fetching the recipe ingredient: \(error)")
                        return
                    }
                    steps = recipeSteps
                }
                
                var ingredients: [RecipeModel.RecipeIngridient]?
                dispatchGroup.enter() // Enter the DispatchGroup before making an asynchronous call
                self.fetchRecipeIngredients(recipeId: id) { (recipeIngredients, error) in
                    defer {
                        dispatchGroup.leave() // Leave the DispatchGroup after the asynchronous call completes
                    }
                    
                    if let error = error {
                        print("Error while fetching the recipe ingredient: \(error)")
                        return
                    }
                    ingredients = recipeIngredients
                }
                
                // Notify when all asynchronous calls inside the DispatchGroup have completed
                dispatchGroup.notify(queue: .main) {
                    if let ingredients = ingredients, let steps = steps {
                        let recipe = RecipeModel(
                            id: document?.documentID as? String ?? "",
                            userId: data["userId"] as? String ?? "",
                            recipeName: data["recipeName"] as? String ?? "",
                            imageName: data["imageName"] as? String ?? "",
                            recipeDescription: data["recipeDescription"] as? String ?? "",
                            ingredients: ingredients,
                            steps: steps
                        )
                        completion(recipe, nil)
                    }
                }

            }
            completion(nil, error)
        }
    }
    
    
    func fetchSteps(recipeId: String, completion: @escaping (_ Steps: [RecipeModel.Step]?, _ error: Error?) -> Void) {
        let recipeIngredientsPath = "recipes/" + recipeId + "/steps"
        db.collection(recipeIngredientsPath).getDocuments() { (querySnapshot, error) in
            guard error == nil else {
                print("error getting recipe ingredient", error ?? "")
                return
            }
            
            var stepsArray: [RecipeModel.Step] = []
            
            for document in querySnapshot!.documents {
                if let step = try? document.data(as: RecipeModel.Step.self) {
                    stepsArray.append(step)
                }
            }
            
            completion(stepsArray, error)
        }
    }
    
    
    func fetchRecipeIngredients(recipeId: String, completion: @escaping (_ recipeIngredients: [RecipeModel.RecipeIngridient]?, _ error: Error?) -> Void) {
        let recipeIngredientsPath = "recipes/" + recipeId + "/RecipeIngridient"
        db.collection(recipeIngredientsPath).getDocuments() { (querySnapshot, error) in
            guard error == nil else {
                print("error getting recipe ingredient", error ?? "")
                return
            }
            
            var ingredientArray: [RecipeModel.RecipeIngridient] = []
            
            let dispatchGroup = DispatchGroup() // Create a DispatchGroup to wait for all asynchronous calls
            
            for document in querySnapshot!.documents {
                if let ingredientId = document["ingredient"] as? String ?? nil {
                    dispatchGroup.enter() // Enter the DispatchGroup before making an asynchronous call
                    self.fetchIngrediets(ingredientId: ingredientId) { (ingredient, error) in
                        defer {
                            dispatchGroup.leave() // Leave the DispatchGroup after the asynchronous call completes
                        }
                        
                        if let error = error {
                            print("Error while fetching the ingredient: \(error)")
                            return
                        }
                        
                        if let ingredient = ingredient {
                            let recipeIngredient = RecipeModel.RecipeIngridient(
                                ingredient: ingredient,
                                quantity: document["quantity"] as? String ?? ""
                            )
                            
                            ingredientArray.append(recipeIngredient)
                        }
                    }
                }
            }
            
            // Notify when all asynchronous calls inside the DispatchGroup have completed
            dispatchGroup.notify(queue: .main) {
                completion(ingredientArray, error)
            }
        }
    }
    
    
    func fetchIngrediets(ingredientId: String, completion: @escaping (_ ingredient: Ingredient?, _ error: Error?) -> Void) {
        db.collection("ingredients").document(ingredientId).getDocument { (document, error) in
            guard error == nil else {
                print("error getting ingredient", error ?? "")
                return
            }
            
            let ingredient = try? document?.data(as: Ingredient.self)
            completion(ingredient, error)
        }
    }
}
