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
    
    
    func addRecipe(recipe: RecipeModel, completion: @escaping (_ recipe: RecipeModel?, _ error: Error?) -> Void) {
        let collectionRef = db.collection("recipes")
        let data: [String: Any] = [
            "userId": recipe.userId,
            "recipeName": recipe.userId,
            "imageName": recipe.imageName,
            "recipeDescription": recipe.recipeDescription ?? nil
        ]
        
        let docRef = collectionRef.addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
                return
            }
        }
        
        if let steps = recipe.steps {
            for step in steps {
                self.addRecipeStep(recipeId: docRef.documentID, recipeStep: step) { (step, error) in
                    if let error = error {
                        print("Error while fetching the user profile: \(error)")
                        return
                    }
                }
            }
        }
        
        if let steps = recipe.steps {
            for step in steps {
                self.addRecipeStep(recipeId: docRef.documentID, recipeStep: step) { (step, error) in
                    if let error = error {
                        print("Error while fetching the user profile: \(error)")
                        return
                    }
                }
            }
        }
        
        if let ingredients = recipe.ingredients {
            for ingredient in ingredients {
                self.addRecipeIngredient(recipeId: docRef.documentID, recipeIngredient: ingredient) { (ingredient, error) in
                    if let error = error {
                        print("Error while fetching the user profile: \(error)")
                        return
                    }
                }
            }
        }
        
        completion(recipe, nil)
    }
    
    
    func addRecipeStep(recipeId: String, recipeStep: RecipeModel.Step, completion: @escaping (_ recipeStep: RecipeModel.Step?, _ error: Error?) -> Void) {
        let data: [String: Any] = [
            "stepNumber": recipeStep.stepNumber,
            "description": recipeStep.description,
            "stepImage": recipeStep.stepImage ?? nil
        ]
        
        let docRef = db.collection("recipes/\(recipeId)/steps").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
                return
            }
        }
        
        completion(recipeStep, nil)
    }
    
    
    func addRecipeIngredient(recipeId: String, recipeIngredient: RecipeModel.RecipeIngridient, completion: @escaping (_ recipeIngredient: RecipeModel.RecipeIngridient?, _ error: Error?) -> Void) {
        let data: [String: Any] = [
            "ingredient": recipeIngredient.ingredient,
            "quantity": recipeIngredient.quantity
        ]
        
        let docRef = db.collection("recipes/\(recipeId)/steps").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
                return
            }
        }
        
        completion(recipeIngredient, nil)
    }
    
    
    func addIngredient(ingredient: Ingredient, completion: @escaping (_ ingredient: Ingredient?, _ error: Error?) -> Void) {
        let data: [String: Any] = [
            "ingredientName": ingredient.imageName,
            "imageName": ingredient.imageName
        ]
        
        let docRef = db.collection("ingredients").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
                return
            }
        }
        
        completion(ingredient, nil)
    }
    
    
    func fetchRecipes(completion: @escaping (_ recipe: [RecipeModel]?, _ error: Error?) -> Void) {
        db.collection("recipes").getDocuments() { (querySnapshot, error) in
            guard error == nil else {
                print("error getting recipes", error ?? "")
                return
            }
            
            var recipesArray: [RecipeModel] = []
            
            for document in querySnapshot!.documents {
                let recipe = RecipeModel(
                    id: document.documentID as String,
                    userId: document["userId"] as? String ?? "",
                    recipeName: document["recipeName"] as? String ?? "",
                    imageName: document["imageName"] as? String ?? "",
                    recipeDescription: document["recipeDescription"] as? String ?? ""
                )
                recipesArray.append(recipe)
            }
            
            completion(recipesArray, error)
        }
    }
    
    
    func fetchRecipeInfo(forRecipe: RecipeModel, completion: @escaping (_ recipe: RecipeModel?, _ error: Error?) -> Void) {
        let dispatchGroup = DispatchGroup() // Create a DispatchGroup to wait for all asynchronous calls
        var steps: [RecipeModel.Step]? = []
        
        dispatchGroup.enter() // Enter the DispatchGroup before making an asynchronous call
        self.fetchSteps(recipeId: forRecipe.id) { (recipeSteps, error) in
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
        self.fetchRecipeIngredients(recipeId: forRecipe.id) { (recipeIngredients, error) in
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
                var recipe = forRecipe
                recipe.ingredients = ingredients
                recipe.steps = steps
                completion(recipe, nil)
            }
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
            
            if let document = document {
                let ingredient = Ingredient(
                    id: ingredientId,
                    ingredientName: document["ingredientName"] as? String ?? "",
                    imageName: document["imageName"] as? String ?? ""
                )
                completion(ingredient, nil)
            }
            
            completion(nil, error)
        }
    }
}