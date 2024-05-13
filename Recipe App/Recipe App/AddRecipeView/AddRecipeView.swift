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
    @State private var isShowingStepImagePicker = false
    @State private var showingIngredientPicker = false
    @State private var selectedIngredientIndex: Int = 0
    @State private var selectedStepIndex: Int = 0
    @State private var isSaving: Bool = false
    @State var saveAlert = false

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
                Section(header: Text("Description")) {
                    TextField("Recipe Description", text: $viewModel.description)
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
                    VStack {
                        ForEach($viewModel.newSteps, id: \.stepNumber) { $step in
                            HStack {
                                Button(action: {
                                    viewModel.newStepImages.remove(at: step.stepNumber-1)
                                    viewModel.newSteps = viewModel.newSteps.filter() {$0 != step}
                                    viewModel.recalculateSteps()
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(Color.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Circle())
                                VStack {
                                    Text("Step " + String(step.stepNumber))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.title3)

                                    TextField("Description", text: $step.description, axis: .vertical)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .textFieldStyle(.roundedBorder)
                                        .foregroundColor(Color(.darkGray))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 7.0)
                                                .stroke(step.description.isEmpty ? Color.red : Color.clear, lineWidth: 1.0)
                                        )
                                }
                                
                                Button(action: {
                                    selectedStepIndex = step.stepNumber - 1
                                    isShowingStepImagePicker = true
                                }) {
                                    if let image = viewModel.newStepImages[step.stepNumber - 1] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(10)
                                            .overlay(
                                                Group {
                                                    Color.black.opacity(0.3)
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 120, height: 120)
                                                        .cornerRadius(10)
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundColor(.white)
                                                        .opacity(0.5)
                                                        .frame(width: 50, height: 50)
                                                }
                                            )
                                    } else {
                                        ZStack {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(10)
                                                .foregroundColor(Color.blue)
                                        }
                                        .frame(width: 120, height: 120)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
                            }
                        }
                        
                        
                        Button(action: {
                            viewModel.newSteps.append(RecipeModel.Step(stepNumber: viewModel.newSteps.count+1, description: ""))
                            viewModel.newStepImages.append(nil)
                        }) {
                            HStack{
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Color.green)
                                Text("Add step")
                                    .padding(.horizontal)
                                    .foregroundColor(Color.blue)
                                Spacer()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
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
                       if viewModel.newSteps.count > 0, viewModel.newSteps.allSatisfy({ !$0.description.isEmpty }), viewModel.newIngredients.count > 0, viewModel.newIngredients.allSatisfy({ !$0.quantity.isEmpty }), viewModel.image != nil, viewModel.name != "" {
                           isSaving = true
                           viewModel.saveRecipe()
                       } else {
                           saveAlert = true
                       }
                    }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $viewModel.image)
            }
            .sheet(isPresented: $isShowingStepImagePicker) {
                ImagePicker(image: $viewModel.newStepImages[selectedStepIndex])
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
                    isSaving = false
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .alert(isPresented: $saveAlert) {
            Alert(
                title: Text("Error saving recipe"),
                message: Text("Please fill in all the recipe details"),
                dismissButton: .cancel()
            )
        }
        .overlay(
            Group {
                if isSaving {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .foregroundColor(.white)
                        )
                }
            }
        )
    }
}
        
struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(auth: AuthModel())
    }
}
