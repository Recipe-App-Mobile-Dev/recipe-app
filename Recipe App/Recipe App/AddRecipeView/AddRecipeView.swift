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
    @State private var isShowingImagePicker2 = false
    
    init(auth: AuthModel) {
        viewModel = AddRecipeViewModel(auth: auth)
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Name")){
                    TextField("Recip Name", text: $viewModel.name)
                }
                Section(header: Text("Image")) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.clear, lineWidth: 0)
                        VStack {
                            if let _ = viewModel.image {
                                viewModel.image?
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
                            Button(action: {
                                viewModel.isShowingImagePicker = true
                            }) {
                                Text("Add Image")
                            }
                        }
                    }
                }
                Section(header: Text("Description")){
                    TextEditor(text: $viewModel.description)
                }
                Section(header: Text("Ingredients")){
                    ForEach(viewModel.ingredientRows.indices, id:\.self) { rowIndex in
                        VStack {
                            HStack {
                                viewModel.ingredientRows[rowIndex].image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 65, height: 65)
                                    .padding()
                                
                                Button(action: {
                                    viewModel.isShowingImagePicker2 = true
                                    viewModel.selectedIngredientIndex = rowIndex
                                }) {
                                    Text("Ingredient Image")
                                        .foregroundStyle(.cyan)
                                    
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.blue, lineWidth: 2)
                            )
                            .padding()
                            
                            HStack {
                                TextField("Ingredient Name", text: $viewModel.ingredientRows[rowIndex].ingredient)
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.blue, lineWidth: 2)
                            )
                            .padding()
                            
                            HStack {
                                TextField("Amount", text: $viewModel.ingredientRows[rowIndex].quantity)
                                    .padding()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.blue, lineWidth: 2)
                            )
                            .padding()
                        }
                    }

                    Button(action: {
                        viewModel.addIngredientRow()
                    }) {
                        Text("Add Ingredient")
                    }
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                   Button("Done") {
                       viewModel.saveRecipe()
                       presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingImagePicker2) {
                ImagePicker(image: $viewModel.ingredientRows[viewModel.selectedIngredientIndex].image, isPresented: $viewModel.isShowingImagePicker2)
            }
            .sheet(isPresented: $viewModel.isShowingImagePicker) {
                ImagePicker(image: $viewModel.image, isPresented: $viewModel.isShowingImagePicker)
            }







                }
            }
        }
        
struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(auth: AuthModel())
    }
}
