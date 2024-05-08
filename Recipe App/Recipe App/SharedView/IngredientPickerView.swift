//
//  IngredientPickerView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 07.05.2024.
//

import Foundation
import SwiftUI

struct IngredientPickerView: View {
    @State var ingredients: [Ingredient]?
    @State var isAllowAddingNew: Bool = true
    @State var isLoading: Bool = false
    @State var adding: Bool = false
    @State var newImage: UIImage?
    @State var newIngredientName: String = ""
    @State var isShowingImagePicker = false
    @Binding var pickedIngredients: [RecipeModel.RecipeIngridient]
    @Binding var showingIngredientPicker: Bool
    private var rep = RecipesRepository()
    private var imagesRepository = ImagesRepository()
    
    public init(pickedIngredients: Binding<[RecipeModel.RecipeIngridient]>, showingIngredientPicker: Binding<Bool>) {
        _pickedIngredients = pickedIngredients
        _showingIngredientPicker = showingIngredientPicker
    }
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView()
            } else {
                List {
                    ForEach(ingredients ?? [], id: \.id) { ingredient in
                        if !(pickedIngredients.map{ $0.ingredient }).contains(ingredient) {
                            Button(action: {
                                pickedIngredients.append(RecipeModel.RecipeIngridient(ingredient: ingredient, quantity: ""))
                                showingIngredientPicker = false
                            }) {
                                HStack {
                                    IngredientView(ingredient: ingredient)
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color.green)
                                }
                            }
                        }
                    }
                    if isAllowAddingNew {
                        if !adding {
                            Button(action: {
                                adding = true
                            }) {
                                HStack{
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color.green)
                                    Text("New ingredient")
                                        .padding(.horizontal)
                                    Spacer()
                                }
                                .padding()
                            }
                        } else {
                            HStack {
                                if let image = newImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(10)
                                        .overlay(
                                            Group {
                                                Color.black.opacity(0.3)
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 60, height: 60)
                                                    .cornerRadius(10)
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.white)
                                                    .opacity(0.5)
                                                    .frame(width: 30, height: 30)
                                            }
                                        )
                                    
                                        .onTapGesture {
                                            isShowingImagePicker = true
                                        }
                                } else {
                                    ZStack {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .cornerRadius(10)
                                    }
                                    .frame(width: 60, height: 60)
                                    .onTapGesture {
                                        isShowingImagePicker = true
                                    }
                                }
                                TextField("Ingredient name", text: $newIngredientName)
                                //.frame(width: UIScreen.main.bounds.width)
                                    .textFieldStyle(.roundedBorder)
                                    .foregroundColor(Color(.darkGray))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 7.0)
                                            .stroke(newIngredientName.isEmpty ? Color.red : Color.clear, lineWidth: 1.0)
                                    )
                                Button(action: { addIngredient() }) {
                                    Text("Save")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $newImage)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.8)
        .background(Color.white)
        .cornerRadius(15.0)
        .shadow(radius: 7)
        .onAppear { loadIngredients() }
    }
    
    func loadIngredients() {
        isLoading = true
        rep.fetchAllIngrediets() { ingredients, error in
            if let error = error {
                print("Error while fetching the ingredients: \(error)")
                return
            } else {
                self.isLoading = false
                self.ingredients = ingredients
            }
        }
    }
    
    func addIngredient() {
        isLoading = true
        if let image = newImage, newIngredientName != "" {
            imagesRepository.uploadImage(folder: "ingredients", image: image) { url in
                if let url = url {
                    let newIngredient = Ingredient(ingredientName: newIngredientName, imageName: url)
                    rep.addIngredient(ingredient: newIngredient) { document, error in
                        if error == nil {
                            self.loadIngredients()
                            adding = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    IngredientPickerView(
        pickedIngredients: Binding<[RecipeModel.RecipeIngridient]>(
            get: { return RecipesDummyData.ToastRecipe.ingredients! },
            set: { _ in }
        ),
        showingIngredientPicker: Binding<Bool>(
            get: { return true },
            set: { _ in }
        )
    )
}
