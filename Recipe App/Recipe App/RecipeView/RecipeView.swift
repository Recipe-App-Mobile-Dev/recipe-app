//
//  RecipeView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.04.2024.
//

import Foundation
import SwiftUI

struct RecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RecipeViewModel
    @State var deletionAlert: Bool = false
    @State var ratingAlert: Bool = false
    @State var isEditing: Bool = false
    
    init(recipe: RecipeModel, auth: AuthModel) {
        viewModel = RecipeViewModel(recipe: recipe, auth: auth)
    }
    
    var body: some View {
        if let fetchedRecipe = viewModel.recipe {
            if isEditing == false {
                VStack {
                    JustRecipeView(recipe: Binding.constant(fetchedRecipe), profile: viewModel.userProfile)
                        .navigationTitle(fetchedRecipe.recipeName)
                    
                    if viewModel.authModel.profile.uid == fetchedRecipe.userId {
                        HStack {
                            Button(action: {
                                isEditing = true
                            }) {
                                ButtonView(text: "Edit", color: Color.green)
                            }
                            .padding(.horizontal, 10.0)
                            
                            Button(action: { deletionAlert = true }) {
                                ButtonView(text: "Delete", color: Color.red)
                            }
                            .padding(.horizontal, 10.0)
                            .alert(isPresented: $deletionAlert) {
                                Alert(
                                    title: Text("Confirm deletion"),
                                    message: Text("Do you want to delete this recipe?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        viewModel.deleteRecipe() {
                                            if viewModel.isDeleted == false {
                                                ProgressView()
                                            } else {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                    } else {
                        HStack {
                            if viewModel.isRated == viewModel.userRating {
                                StarsView(stars: $viewModel.userRating, allowRate: false)
                                HStack {
                                    Text("You rated")
                                    Image(systemName: "star.bubble")
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8.0)
                            } else {
                                StarsView(stars: $viewModel.userRating, allowRate: true)
                                if let rating = viewModel.userRating {
                                    Button(action: { ratingAlert = true }) {
                                        ButtonView(text: "Rate", color: Color.yellow)
                                    }
                                    .onSubmit {
                                        viewModel.getUsersRating()
                                    }
                                } else {
                                    ButtonView(text: "Rate", color: Color(red: 0.75, green: 0.75, blue: 0.75))
                                }
                            }
                        }
                        .onAppear {
                            viewModel.getUsersRating()
                        }
                        .alert(isPresented: $ratingAlert) {
                            Alert(
                                title: Text("Confirm rating \(viewModel.userRating!)★"),
                                message: Text("Do you want to rate this recipe?"),
                                primaryButton: .cancel(),
                                secondaryButton: .default(Text("Confirm")) {
                                    viewModel.rateRecipe()
                                }
                            )
                        }
                    }
                }
                .onAppear{ viewModel.reloadRecipe(recipe: viewModel.recipe!) }
            } else {
                EditRecipeView(recipe: Binding.constant(fetchedRecipe), isEditing: $isEditing)
                    .navigationTitle("Editing " + fetchedRecipe.recipeName)
            }
        } else {
            ProgressView()
        }
    }
}


#Preview {
    RecipeView(
        recipe: RecipesDummyData.ToastRecipe,
        auth: AuthModel(testProfile: true)
    )
}
