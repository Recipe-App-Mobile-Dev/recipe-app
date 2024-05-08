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
    @State private var showingIngredientPicker = false
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
                    VStack {
                        ForEach($viewModel.newIngredients, id: \.ingredient.id) { $recipeIngredient in
                            HStack {
                                Button(action: {
                                    viewModel.newIngredients = viewModel.newIngredients.filter() {$0 != recipeIngredient}
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(Color.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Circle())
                                IngredientView(ingredient: recipeIngredient.ingredient)
                                Spacer()
                                TextField("Quantity", text: $recipeIngredient.quantity, axis: .vertical)
                                    .frame(width: UIScreen.main.bounds.width * 0.3)
                                    .textFieldStyle(.roundedBorder)
                                    .foregroundColor(Color(.darkGray))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 7.0)
                                            .stroke(recipeIngredient.quantity.isEmpty ? Color.red : Color.clear, lineWidth: 1.0)
                                    )
                            }
                            .padding(.vertical, 3.0)
                        }
                        
                        HStack{
                            Button(action: {
                                showingIngredientPicker = true
                            }) {
                                HStack{
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color.green)
                                    Text("Add ingredient")
                                        .padding(.horizontal)
                                        .foregroundColor(Color.blue)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contentShape(Rectangle())

                            Spacer()
                        }
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
                        HStack{
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color.green)
                            Text("Add Procedure")
                                .padding(.horizontal)
                        }
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
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                   Button("Done") {
                       viewModel.saveRecipe()
                    }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $viewModel.image)
            }
            .overlay(
                Group {
                    if showingIngredientPicker {
                        Group {
                            Color.black.opacity(0.3)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    showingIngredientPicker = false
                                }
                            IngredientPickerView(pickedIngredients: $viewModel.newIngredients, showingIngredientPicker: $showingIngredientPicker)
                        }
                    } else {
                        EmptyView()
                    }
                }
            )
            .onAppear {
                viewModel.onSaveCompleted = {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
        
struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(auth: AuthModel())
    }
}
