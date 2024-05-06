//
//  ContentView.swift
//  AddRecipeView
//
//  Created by Charlene on 16/04/2024.
//

import SwiftUI
import UIKit

struct AddRecipeView: View {
    @ObservedObject var viewModel: AddRecipeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingImagePicker = false
    @State private var isShowingIngredientImagePicker = false
    @State private var selectedIngredientIndex: Int = 0

    init(auth: AuthModel) {
        viewModel = AddRecipeViewModel(auth: auth)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Recipe Name", text: $viewModel.name)
                }
                Section(header: Text("Image")) {
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        HStack{
                            Spacer()
                            if let image = viewModel.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                    }
                }
                Section(header: Text("Ingredients")) {
                    ForEach(viewModel.ingredientRows.indices, id: \.self) { rowIndex in
                        HStack {
                            Button(action: {
                                selectedIngredientIndex = rowIndex
                                isShowingIngredientImagePicker = true
                            }) {
                                if let image = viewModel.ingredientRows[rowIndex].image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                } else {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                }
                            }
                            TextField("Ingredient Name", text: $viewModel.ingredientRows[rowIndex].ingredient)
                            TextField("Amount", text: $viewModel.ingredientRows[rowIndex].quantity)
                        }
                    }
                    Button("Add Ingredient", action: viewModel.addIngredientRow)
                }
                Section(header: Text("Directions")) {
                    ForEach(viewModel.procedures.indices, id:\.self) { index in
                        Text("Step \(index + 1)")
                        TextEditor(text: $viewModel.procedures[index])
                    }
                    Button(action: {
                        viewModel.addProcedure()
                    }) {
                        Text("Add Procedure")
                    }
                }
                Section(header: Text("Categories")){
                    ScrollView(.horizontal, showsIndicators:false){
                        LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
                            ForEach(Category.allCases){
                                category in
                                Button(action: {
                                    viewModel.toggleCategorySelection(category)
                                }) {
                                    Text(category.rawValue)
                                        .foregroundColor(viewModel.selectedCategories.contains(category) ? .white : .blue)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(viewModel.selectedCategories.contains(category) ? Color.blue : Color.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Recipe")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                   Button("Done") {
                       viewModel.saveRecipe()
                       presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $viewModel.image)
            }
            .sheet(isPresented: $isShowingIngredientImagePicker) {
                ImagePicker(image: $viewModel.ingredientRows[selectedIngredientIndex].image)
            }
        }
    }
}
        
struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(auth: AuthModel())
    }
}
