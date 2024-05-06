//
//  AddRecipeViewModel.swift
//  Recipe App
//
//  Created by 吴金泳 on 05/05/2024.
//

import Foundation
import SwiftUI
import UIKit

struct IngredientData {
    var image: Image?
    var ingredient: String
    var quantity: String
}

class AddRecipeViewModel: ObservableObject {
    @ObservedObject var authModel: AuthModel
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var image: Image?
    @Published var isShowingImagePicker = false
    @Published var isShowingImagePicker2 = false
    @Published var selectedIngredientIndex = 0
    @Published var procedures: [String] = []
    @Published var selectedCategories: [Category] = []
    @Published var ingredientRows: [IngredientData] = []
    @Environment(\.presentationMode) var presentationMode
    
    init(auth: AuthModel) {
        self.authModel = auth
    }
    
    func addProcedure() {
        procedures.append("")
    }
    
    func toggleCategorySelection(_ category: Category){
        if selectedCategories.contains(category) {
            selectedCategories.removeAll{ $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }
    
    func addIngredientRow() {
        var newRow = IngredientData(image: nil, ingredient: "", quantity: "")
        ingredientRows.append(newRow)
    }
    
    func saveRecipe() {
        var rep = RecipesRepository()
        
        let newRecipe = NewRecipeModel(
            userId: authModel.profile.uid,
            recipeName: name,
            imageName: image,
            recipeDescription: description,
            ingredients: ingredientRows.map { NewRecipeModel.RecipeIngridient(ingredient: NewIngredient(ingredientName: $0.ingredient, image: $0.image), quantity: $0.quantity) },
            steps: procedures.enumerated().map { index, stepDescription in
                NewRecipeModel.Step(stepNumber: index, description: stepDescription)
            },
            categories: selectedCategories
        )
        
        rep.addRecipe(recipe: newRecipe) { (ingredient, error) in
            if let error = error {
                print("Error while adding a new recipe: \(error)")
                return
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = Image(uiImage: uiImage)
            }

            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
