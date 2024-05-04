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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateString = dateFormatter.string(from: Date())
        
        var stringCategories: [String]?
        if let enumCategories = recipe.categories {
            print(enumCategories)
            stringCategories = enumCategories.map { $0.rawValue }
            print(stringCategories)
        }
        
        let data: [String: Any] = [
            "userId": recipe.userId,
            "recipeName": recipe.recipeName,
            "imageName": recipe.imageName,
            "recipeDescription": recipe.recipeDescription ?? nil,
            "categories": stringCategories ?? nil,
            "dateCreated": dateString
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
                        print("Error adding recipe steps: \(error)")
                        return
                    }
                }
            }
        }
        
        if let ingredients = recipe.ingredients {
            for ingredient in ingredients {
                self.addRecipeIngredient(recipeId: docRef.documentID, recipeIngredient: ingredient) { (ingredient, error) in
                    if let error = error {
                        print("Error adding recipe ingredients: \(error)")
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
                print("Error adding step: \(error)")
                return
            }
        }
        
        let recipeRef = db.collection("recipes").document(recipeId)
        recipeRef.updateData(["steps": FieldValue.arrayUnion([docRef.documentID])]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            }
        }
        
        completion(recipeStep, nil)
    }
    
    
    func addRecipeIngredient(recipeId: String, recipeIngredient: RecipeModel.RecipeIngridient, completion: @escaping (_ recipeIngredient: RecipeModel.RecipeIngridient?, _ error: Error?) -> Void) {
        let data: [String: Any] = [
            "ingredient": recipeIngredient.ingredient.id,
            "quantity": recipeIngredient.quantity
        ]
        
        let docRef = db.collection("recipes/\(recipeId)/RecipeIngridient").addDocument(data: data) { error in
            if let error = error {
                print("Error adding ingredient: \(error)")
                return
            }
        }
        
        let recipeRef = db.collection("recipes").document(recipeId)
        recipeRef.updateData(["ingredients": FieldValue.arrayUnion([docRef.documentID])]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } 
        }
        
        completion(recipeIngredient, nil)
    }
    
    
    func addIngredient(ingredient: Ingredient, completion: @escaping (_ ingredient: Ingredient?, _ error: Error?) -> Void) {
        let data: [String: Any] = [
            "ingredientName": ingredient.ingredientName,
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
    
    
    func addRecipeRating(stars: Int, recipeId: String, userId: String, completion: @escaping (_ error: Error?) -> Void) {
        let data: [String: Any] = [
            "userId": userId,
            "stars": stars
        ]
        let recipeIngredientsPath = "recipes/" + recipeId + "/rating"
        
        let docRef = db.collection(recipeIngredientsPath).addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
                return
            }
            
            completion(error)
        }
    }
    
    
    func fetchRecipes(completion: @escaping (_ recipe: [RecipeModel]?, _ error: Error?) -> Void) {
        let dispatchGroup = DispatchGroup() // Create a DispatchGroup to wait for all asynchronous calls
        db.collection("recipes").getDocuments() { (querySnapshot, error) in
            guard error == nil else {
                print("error getting recipes", error ?? "")
                return
            }
            
            var recipesArray: [RecipeModel] = []
            
            for document in querySnapshot!.documents {
                if let dateString = document["dateCreated"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    if let date = dateFormatter.date(from: dateString) {
                        var recipe = RecipeModel(
                            id: document.documentID as String,
                            userId: document["userId"] as? String ?? "",
                            recipeName: document["recipeName"] as? String ?? "",
                            imageName: document["imageName"] as? String ?? "",
                            recipeDescription: document["recipeDescription"] as? String ?? nil,
                            categories: document["categories"] as? [Category] ?? nil,
                            dateCreated: date
                        )
                        
                        if let categoriesArray = document["categories"] as? [String] ?? nil {
                            var enumCategories = categoriesArray.compactMap { Category(rawValue: $0) }
                            recipe.categories = enumCategories
                        }
                        
                        dispatchGroup.enter() // Enter the DispatchGroup before making an asynchronous call
                        self.fetchRecipeRating(recipeId: document.documentID) { rating, error in
                            defer {
                                dispatchGroup.leave() // Leave the DispatchGroup after the asynchronous call completes
                            }
                            
                            guard error == nil else {
                                print("error getting rating", error ?? "")
                                return
                            }
                            
                            if let rating = rating {
                                recipe.rating = rating
                            }
                            
                            recipesArray.append(recipe)
                        }
                    }
                }
            
                dispatchGroup.notify(queue: .main) {
                    completion(recipesArray, nil)
                }
            }
        }
    }
    
    
    func fetchUserRecipes(userId: String, completion: @escaping (_ recipe: [RecipeModel]?, _ error: Error?) -> Void) {
        let dispatchGroup = DispatchGroup() // Create a DispatchGroup to wait for all asynchronous calls
        db.collection("recipes").whereField("userId", isEqualTo: userId).getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error getting recipes: \(error?.localizedDescription ?? "")")
                completion(nil, error)
                return
            }

            var recipesArray: [RecipeModel] = []

            for document in querySnapshot.documents {
                if let dateString = document["dateCreated"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    if let date = dateFormatter.date(from: dateString) {
                        var recipe = RecipeModel(
                            id: document.documentID as String,
                            userId: document["userId"] as? String ?? "",
                            recipeName: document["recipeName"] as? String ?? "",
                            imageName: document["imageName"] as? String ?? "",
                            recipeDescription: document["recipeDescription"] as? String ?? nil,
                            dateCreated: date
                        )
                        
                        if let categoriesArray = document["categories"] as? [String] ?? nil {
                            var enumCategories = categoriesArray.compactMap { Category(rawValue: $0) }
                            recipe.categories = enumCategories
                        }
                        
                        dispatchGroup.enter() // Enter the DispatchGroup before making an asynchronous call
                        self.fetchRecipeRating(recipeId: document.documentID) { rating, error in
                            defer {
                                dispatchGroup.leave() // Leave the DispatchGroup after the asynchronous call completes
                            }
                            
                            guard error == nil else {
                                print("error getting rating", error ?? "")
                                return
                            }
                            
                            if let rating = rating {
                                recipe.rating = rating
                            }
                            
                            recipesArray.append(recipe)
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(recipesArray, nil)
                }
            }
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
    
    
    func fetchRecipeRating(recipeId: String, completion: @escaping (_ rating: Double?, _ error: Error?) -> Void) {
        let recipeIngredientsPath = "recipes/" + recipeId + "/rating"
        db.collection(recipeIngredientsPath).getDocuments() { (querySnapshot, error) in
            guard error == nil else {
                print("error getting recipe ingredient", error ?? "")
                return
            }
            
            var ratingArray: [Double] = []
            
            for document in querySnapshot!.documents {
                if let rate = document["stars"] as? Double {
                    //print(rate)
                    ratingArray.append(rate)
                }
            }
            
            if ratingArray.count > 0 {
                var arraySum = ratingArray.reduce(0, +)
                var rating = Double(arraySum)/Double(ratingArray.count)
                //print("done", rating)
                completion(rating, nil)
            } else {
                completion(nil, error)
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
                    id: document.documentID,
                    ingredientName: document["ingredientName"] as? String ?? "",
                    imageName: document["imageName"] as? String ?? ""
                )
                completion(ingredient, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func fetchUsersRecipeRating(recipeId: String, userId: String, completion: @escaping (_ rating: Int?, _ error: Error?) -> Void) {
        let recipeIngredientsPath = "recipes/" + recipeId + "/rating"
        
        print(recipeId)
        print(userId)
        print(recipeIngredientsPath)
        db.collection(recipeIngredientsPath).whereField("userId", isEqualTo: userId).getDocuments { documents, error in
            guard error == nil else {
                print("error getting user rating", error ?? "")
                return
            }
            
            if let documents = documents {
                for document in documents.documents {
                    if let rate = document["stars"] as? Int {
                        completion(rate, nil)
                    }
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func deleteRecipe(recipeId: String, completion: @escaping (_ error: Error?) -> Void) {
        let steps = "recipes/\(recipeId)/steps"
        deleteCollection(collectionName: steps) { error in
            if let error = error {
                print("Error deleting collection: \(error.localizedDescription)")
                return
            } else {
                print("Collection deleted successfully.")
            }
        }
        
        let ingredients = "recipes/\(recipeId)/RecipeIngridient"
        deleteCollection(collectionName: ingredients) { error in
            if let error = error {
                print("Error deleting collection: \(error.localizedDescription)")
                return
            } else {
                print("Collection deleted successfully.")
            }
        }
        
        let docRef = db.collection("recipes").document(recipeId).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
                completion(error)
            }
        }
        
        completion(nil)
    }
    
    func deleteCollection(collectionName: String, batchSize: Int = 100, completion: @escaping (Error?) -> Void) {
        let collectionRef = db.collection(collectionName)
        // Get the documents in the collection
        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(error)
                return
            }
            
            // Create a batch operation
            let batch = collectionRef.firestore.batch()
            
            // Iterate over the documents in batches and delete them
            snapshot.documents.enumerated().forEach { index, document in
                batch.deleteDocument(document.reference)
                
                // Commit the batch after every batchSize documents
                if index % batchSize == (batchSize - 1) || index == snapshot.documents.count - 1 {
                    batch.commit { batchError in
                        if let batchError = batchError {
                            completion(batchError)
                        }
                    }
                }
            }
        }
    }
}
