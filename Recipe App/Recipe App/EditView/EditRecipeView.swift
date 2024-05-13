//
//  EditRecipeView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 04.05.2024.
//

import Foundation
import SwiftUI

struct EditRecipeView: View {
    @ObservedObject var viewModel: RecipeEditViewModel
    @State var showingIngredientPicker = false
    @State var isShowingImagePicker = false
    @State var isShowingStepImagePicker = false
    @State var selectedStepIndex: Int = 0
    @State var errorAlert: Bool = false
    @State var errorMessage: String = ""
    @State var isSaving: Bool = false
    @Binding var isEditing: Bool
    
    init(recipe: Binding<RecipeModel>, isEditing: Binding<Bool>) {
        self.viewModel = RecipeEditViewModel(recipe: recipe)
        _isEditing = isEditing
    }
    
    var body: some View {
        Group {
            ScrollView {
                Button(action: {
                    isShowingImagePicker = true
                }) {
                    if let image = viewModel.editingMainImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                            .cornerRadius(10)
                            .padding()
                            .overlay(
                                Group {
                                    Color.black.opacity(0.3)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                                        .cornerRadius(10)
                                        .padding()
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .opacity(0.5)
                                        .frame(width: 100, height: 100)
                                }
                            )
                    } else {
                        LoadImageView(imageName: viewModel.editingMainImageName)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                            .cornerRadius(10)
                            .padding()
                            .overlay(
                                Group {
                                    Color.black.opacity(0.3)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                                        .cornerRadius(10)
                                        .padding()
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .opacity(0.5)
                                        .frame(width: 100, height: 100)
                                }
                            )
                    }
                }
                
                TextField("Enter description", text: $viewModel.editingDescription, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(Color(.darkGray))
                    .padding()
                
                VStack {
                    Text("Ingredients")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .padding(.bottom, 10.0)
                    
                    ForEach($viewModel.editingIngredients, id: \.ingredient.id) { $recipeIngredient in
                        HStack {
                            Button(action: {
                                viewModel.editingIngredients = viewModel.editingIngredients.filter() {$0 != recipeIngredient}
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color.red)
                            }
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
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color.green)
                            Text("Add ingredient")
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    .padding(.top)
                }
                .padding()
                
                VStack {
                    Text("Procedures")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title2)
                        .padding(.bottom, 10.0)
                    
                    ForEach($viewModel.editingSteps, id: \.stepNumber) { $step in
                        HStack {
                            Button(action: {
                                viewModel.editingStepImages.remove(at: step.stepNumber-1)
                                viewModel.editingSteps = viewModel.editingSteps.filter() {$0 != step}
                                viewModel.recalculateSteps()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color.red)
                            }
                            VStack {
                                Text("Step " + String(step.stepNumber))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title3)
                                    .padding(.bottom, 3.0)
                                
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
                                if let image = viewModel.editingStepImages[step.stepNumber - 1] {
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
                                    if let stepHasImage = step.stepImage {
                                        LoadImageView(imageName: stepHasImage)
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
                                        }
                                        .frame(width: 120, height: 120)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 10.0)
                    
                    HStack{
                        Button(action: {
                            viewModel.editingSteps.append(RecipeModel.Step(stepNumber: viewModel.editingSteps.count+1, description: ""))
                            viewModel.editingStepImages.append(nil)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color.green)
                            Text("Add step")
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                }
                .padding()
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $viewModel.editingMainImage)
            }
            .sheet(isPresented: $isShowingStepImagePicker) {
                ImagePicker(image: $viewModel.editingStepImages[selectedStepIndex])
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
                            IngredientPickerView(pickedIngredients: $viewModel.editingIngredients, showingIngredientPicker: $showingIngredientPicker)
                        }
                    } else {
                        EmptyView()
                    }
                }
            )
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
            
            HStack {
                Button(action: {
                    isSaving = true
                    viewModel.saveChanges() { done, error in
                        if done {
                            isSaving = false
                            isEditing = false
                        } else {
                            isSaving = false
                            errorAlert = true
                            errorMessage = error!
                        }
                    }
                }) {
                    ButtonView(text: "Save", color: Color.green)
                }
                .padding(.horizontal, 10.0)
                .disabled(isSaving)
                
                Button(action: { isEditing = false }) {
                    ButtonView(text: "Cancel", color: Color.blue)
                }
                .padding(.horizontal, 10.0)
                .disabled(isSaving)
            }
            .alert(isPresented: $errorAlert) {
                Alert(
                    title: Text("Error saving recipe"),
                    message: Text(errorMessage),
                    dismissButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    EditRecipeView(
        recipe: Binding<RecipeModel> (
            get: { return RecipesDummyData.ToastRecipe },
            set: { _ in }
        ),
        isEditing: Binding<Bool> (
            get: { return true },
            set: { _ in }
        )
    )
}
