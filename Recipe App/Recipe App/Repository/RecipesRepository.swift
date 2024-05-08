//
//  RecipesRepository.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 26.04.2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

class RecipesRepository: ObservableObject {
    private var db = Firestore.firestore()
    
    
    func reloadRecipe(recipeId: String, completion: @escaping (_ recipe: RecipeModel?, _ error: Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        db.collection("recipes").document(recipeId).getDocument { document, error in
            guard error == nil else {
                print("error getting recipes", error ?? "")
                return
            }
            
            if let document = document {
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
                        
                        dispatchGroup.enter()
                        self.fetchRecipeRating(recipeId: document.documentID) { rating, error in
                            defer {
                                dispatchGroup.leave()
                            }
                            
                            guard error == nil else {
                                print("error getting rating", error ?? "")
                                return
                            }
                            
                            if let rating = rating {
                                recipe.rating = rating
                            }
                        }
                        
                        var steps: [RecipeModel.Step]? = []
                        dispatchGroup.enter()
                        self.fetchSteps(recipeId: document.documentID) { (recipeSteps, error) in
                            defer {
                                dispatchGroup.leave()
                            }
                            
                            if let error = error {
                                print("Error while fetching the recipe ingredient: \(error)")
                                return
                            }
                            steps = recipeSteps
                        }
                        
                        var ingredients: [RecipeModel.RecipeIngridient]?
                        dispatchGroup.enter()
                        self.fetchRecipeIngredients(recipeId: document.documentID) { (recipeIngredients, error) in
                            defer {
                                dispatchGroup.leave()
                            }
                            
                            if let error = error {
                                print("Error while fetching the recipe ingredient: \(error)")
                                return
                            }
                            ingredients = recipeIngredients
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            if let ingredients = ingredients, let steps = steps {
                                recipe.ingredients = ingredients
                                recipe.steps = steps
                                completion(recipe, nil)
                            } else {
                                completion(nil, error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func addRecipe(recipe: NewRecipeModel, newStepImages: [UIImage?], completion: @escaping (_ recipe: NewRecipeModel?, _ error: Error?) -> Void) {
        let collectionRef = db.collection("recipes")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateString = dateFormatter.string(from: Date())
        
        var stringCategories: [String]?
        if let enumCategories = recipe.categories {
            stringCategories = enumCategories.map { $0.rawValue }
        }
        
        if let image = recipe.imageName, let imageData = image.jpegData(compressionQuality: 0.8) {
            let storageRef = Storage.storage().reference().child("recipe_images").child("\(UUID().uuidString).jpg")
            
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    completion(nil, error)
                    return
                }
                
                self.addRecipeToFirestore(recipe: recipe, imageUrl: storageRef.fullPath, dateString: dateString, stringCategories: stringCategories, newStepImages: newStepImages, completion: completion)
            }
        } else {
            self.addRecipeToFirestore(recipe: recipe, imageUrl: nil, dateString: dateString, stringCategories: stringCategories, newStepImages: newStepImages, completion: completion)
        }
    }
    
    private func addRecipeToFirestore(recipe: NewRecipeModel, imageUrl: String?, dateString: String, stringCategories: [String]?, newStepImages: [UIImage?], completion: @escaping (_ recipe: NewRecipeModel?, _ error: Error?) -> Void) {
        let data: [String: Any] = [
            "userId": recipe.userId,
            "recipeName": recipe.recipeName,
            "imageName": imageUrl ?? "", // Save the image URL
            "recipeDescription": recipe.recipeDescription ?? nil,
            "categories": stringCategories ?? nil,
            "dateCreated": dateString
        ]
        
        let docRef = db.collection("recipes").addDocument(data: data) { error in
            if let error = error {
                completion(nil, error)
                return
            } else {
                completion(recipe, nil)
            }
        }

                
        if let steps = recipe.steps {
            self.addRecipeSteps(recipeId: docRef.documentID, recipeSteps: steps, newStepImages: newStepImages) { (error) in
                if let error = error {
                    print("Error adding recipe steps: \(error)")
                    return
                }
            }
        }
                
        if let ingredients = recipe.ingredients {
            self.addRecipeIngredient(recipeId: docRef.documentID, recipeIngredients: ingredients) { error in
                if let error = error {
                    print("Error adding recipe ingredients: \(error)")
                    return
                }
            }
        }
        
        completion(recipe, nil)
    }
    
    func addRecipeSteps(recipeId: String, recipeSteps: [RecipeModel.Step], newStepImages: [UIImage?], completion: @escaping (_ error: Error?) -> Void) {
        let storageRef = Storage.storage().reference()
        let stepsCollection = Firestore.firestore().collection("recipes/\(recipeId)/steps")

        stepsCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }

            snapshot?.documents.forEach { document in
                stepsCollection.document(document.documentID).delete()
            }

            let dispatchGroup = DispatchGroup()

            for (index, step) in recipeSteps.enumerated() {
                dispatchGroup.enter()
                
                let imageName = "step\(index + 1).jpg"
                let imagePath = "recipesteps/\(recipeId)/\(imageName)"
                let imageRef = storageRef.child(imagePath)

                if let image = newStepImages[index], let imageData = image.jpegData(compressionQuality: 0.8) {
                    imageRef.putData(imageData, metadata: nil) { metadata, error in
                        guard let metadata = metadata else {
                            dispatchGroup.leave()
                            return
                        }
                        
                        var stepData: [String: Any] = [
                            "stepNumber": step.stepNumber,
                            "description": step.description,
                            "stepImage": imageName
                        ]
                        
                        stepsCollection.addDocument(data: stepData) { error in
                            if let error = error {
                                completion(error)
                            }
                            dispatchGroup.leave()
                        }
                    }
                } else {
                    let stepData: [String: Any] = [
                        "stepNumber": step.stepNumber,
                        "description": step.description,
                        "stepImage": ""
                    ]
                    stepsCollection.addDocument(data: stepData) { error in
                        if let error = error {
                            completion(error)
                        }
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(nil)
            }
        }
    }
    
    func addRecipeIngredient(recipeId: String, recipeIngredients: [RecipeModel.RecipeIngridient], completion: @escaping (_ error: Error?) -> Void) {
        let ingredientsCollection = db.collection("recipes/\(recipeId)/RecipeIngridient")
        
        ingredientsCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            snapshot?.documents.forEach { document in
                ingredientsCollection.document(document.documentID).delete()
            }
            
            for ingredient in recipeIngredients {
                let data: [String: Any] = [
                    "ingredient": ingredient.ingredient.id,
                    "quantity": ingredient.quantity
                ]
                
                ingredientsCollection.addDocument(data: data) { error in
                    if let error = error {
                        completion(error)
                    }
                }
            }
            
            completion(nil)
        }
    }

    private func addIngredientDocument(recipeId: String, recipeIngredient: RecipeModel.RecipeIngridient, imageUrl: String?, completion: @escaping (_ recipeIngredient: RecipeModel.RecipeIngridient?, _ error: Error?) -> Void) {
        var data: [String: Any] = [
            "ingredientName": recipeIngredient.ingredient.ingredientName,
            "quantity": recipeIngredient.quantity
        ]
        
        if let imageUrl = imageUrl {
            data["imageUrl"] = imageUrl
        }

        let docRef = db.collection("recipes/\(recipeId)/RecipeIngridient").addDocument(data: data) { error in
            if let error = error {
                completion(nil, error)
                return
            }
        }
        
        let recipeRef = self.db.collection("recipes").document(recipeId)
        recipeRef.updateData(["ingredients": FieldValue.arrayUnion([docRef.documentID])]) { error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(recipeIngredient, nil)
            }
        }
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
                print("Error adding rating: \(error)")
                return
            }
            
            completion(error)
        }
    }
    
    
    func fetchRecipes(completion: @escaping (_ recipe: [RecipeModel]?, _ error: Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
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
                        
                        dispatchGroup.enter()
                        self.fetchRecipeRating(recipeId: document.documentID) { rating, error in
                            defer {
                                dispatchGroup.leave()
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
        let dispatchGroup = DispatchGroup()
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
                        
                        dispatchGroup.enter()
                        self.fetchRecipeRating(recipeId: document.documentID) { rating, error in
                            defer {
                                dispatchGroup.leave()
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
        let dispatchGroup = DispatchGroup()
        
        var steps: [RecipeModel.Step]? = []
        dispatchGroup.enter()
        self.fetchSteps(recipeId: forRecipe.id) { (recipeSteps, error) in
            defer {
                dispatchGroup.leave()
            }
            
            if let error = error {
                print("Error while fetching the recipe ingredient: \(error)")
                return
            }
            steps = recipeSteps
        }
                
        var ingredients: [RecipeModel.RecipeIngridient]?
        dispatchGroup.enter()
        self.fetchRecipeIngredients(recipeId: forRecipe.id) { (recipeIngredients, error) in
            defer {
                dispatchGroup.leave()
            }
            
            if let error = error {
                print("Error while fetching the recipe ingredient: \(error)")
                return
            }
            ingredients = recipeIngredients
        }
                
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
                print("error getting recipe rating", error ?? "")
                return
            }
            
            var ratingArray: [Double] = []
            
            for document in querySnapshot!.documents {
                if let rate = document["stars"] as? Double {
                    ratingArray.append(rate)
                }
            }
            
            if ratingArray.count > 0 {
                var arraySum = ratingArray.reduce(0, +)
                var rating = Double(arraySum)/Double(ratingArray.count)
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
                print("error getting recipe steps", error ?? "")
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
                print("error getting recipe ingredients", error ?? "")
                return
            }
            
            var ingredientArray: [RecipeModel.RecipeIngridient] = []
            
            let dispatchGroup = DispatchGroup()
            
            for document in querySnapshot!.documents {
                if let ingredientId = document["ingredient"] as? String ?? nil {
                    dispatchGroup.enter()
                    self.fetchIngrediets(ingredientId: ingredientId) { (ingredient, error) in
                        defer {
                            dispatchGroup.leave()
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
    
    
    func fetchAllIngrediets(completion: @escaping (_ ingredients: [Ingredient]?, _ error: Error?) -> Void) {
        db.collection("ingredients").getDocuments { (document, error) in
            guard error == nil else {
                print("error getting ingredient", error ?? "")
                return
            }
            
            var ingredients: [Ingredient] = []

            for document in document!.documents {
                let data = document.data()
                let ingredientName = data["ingredientName"] as? String ?? ""
                let imageName = data["imageName"] as? String ?? ""

                let ingredient = Ingredient(
                    id: document.documentID,
                    ingredientName: ingredientName,
                    imageName: imageName
                )
                ingredients.append(ingredient)
            }

            completion(ingredients, nil)
        }
    }
    
    
    func fetchUsersRecipeRating(recipeId: String, userId: String, completion: @escaping (_ rating: Int?, _ error: Error?) -> Void) {
        let recipeIngredientsPath = "recipes/" + recipeId + "/rating"
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
  
    func updateRecipe(recipeId: String, recipe: RecipeModel, completion: @escaping (_ done: Bool, _ error: Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        let docRef = db.collection("recipes").document(recipeId)
        
        let data: [String: Any] = [
            "imageName": recipe.imageName,
            "recipeDescription": recipe.recipeDescription ?? FieldValue.delete(),
            "steps": []
        ]
        
        dispatchGroup.enter()
        docRef.updateData(data) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        updateRecipeSteps(recipeId: recipeId, recipeSteps: recipe.steps ?? []) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        updateRecipeIngredients(recipeId: recipeId, recipeIngredients: recipe.ingredients ?? []) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(true, nil)
        }
    }
    
    func updateRecipeSteps(recipeId: String, recipeSteps: [RecipeModel.Step], completion: @escaping (_ error: Error?) -> Void) {
        let stepsCollection = db.collection("recipes/\(recipeId)/steps")
        
        stepsCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            snapshot?.documents.forEach { document in
                stepsCollection.document(document.documentID).delete()
            }
            
            for step in recipeSteps {
                let data: [String: Any] = [
                    "stepNumber": step.stepNumber,
                    "description": step.description,
                    "stepImage": step.stepImage ?? ""
                ]
                
                stepsCollection.addDocument(data: data) { error in
                    if let error = error {
                        completion(error)
                    }
                }
            }
            
            completion(nil)
        }
    }
    
    
    func updateRecipeIngredients(recipeId: String, recipeIngredients: [RecipeModel.RecipeIngridient], completion: @escaping (_ error: Error?) -> Void) {
        let ingredientsCollection = db.collection("recipes/\(recipeId)/RecipeIngridient")
        
        ingredientsCollection.getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            snapshot?.documents.forEach { document in
                ingredientsCollection.document(document.documentID).delete()
            }
            
            for ingredient in recipeIngredients {
                let data: [String: Any] = [
                    "ingredient": ingredient.ingredient.id,
                    "quantity": ingredient.quantity
                ]
                
                ingredientsCollection.addDocument(data: data) { error in
                    if let error = error {
                        completion(error)
                    }
                }
            }
            
            completion(nil)
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
                print("Error deleting recipe: \(error)")
                completion(error)
            }
        }
        
        completion(nil)
    }
    
    func deleteCollection(collectionName: String, batchSize: Int = 100, completion: @escaping (Error?) -> Void) {
        let collectionRef = db.collection(collectionName)
        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                completion(error)
                return
            }
            
            let batch = collectionRef.firestore.batch()
            
            snapshot.documents.enumerated().forEach { index, document in
                batch.deleteDocument(document.reference)
                
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
