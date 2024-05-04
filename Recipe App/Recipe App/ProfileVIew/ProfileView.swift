//
//  ProfileView.swift
//  Recipe App
//
//  Created by Jin Mizuno on 30/04/2024.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var path: NavigationPath
    var authModel: AuthModel
    
    init(test: Bool? = false, authModel: AuthModel, path: Binding<NavigationPath>) {
        viewModel = ProfileViewModel(test: test, userId: authModel.profile.uid)
        self.authModel = authModel
        _path = path
    }

    var body: some View {        
        if let fetchedRecipes = viewModel.recipes {
            ScrollView {
                VStack {
                    HStack {
                        ProfileCardView(profile: authModel.profile)
                        Image(systemName: "pencil")
                            .padding(.trailing, 20)
                        
                    }.padding(.top, 30)
                    
                    VStack(spacing: 20) {
                        ForEach(fetchedRecipes.sorted(by: { $0.dateCreated > $1.dateCreated }), id: \.id) { recipe in
                            NavigationLink(value: recipe) {
                                RecipeCardView(imageName: recipe.imageName, recipeName: recipe.recipeName)
                            }
                        }
                    }
                    
                    .padding()
                    .padding(.top, 20)
                    
                    Button("Log Out") {
                        authModel.signOut()
                    }
                    
                    Button("TEST add dummy recipe") {
                        RecipesDummyData.addDataToFirebase()
                    }
                    .padding()
                }
            }
            .navigationDestination(for: RecipeModel.self) { recipe in
                RecipeView(recipe: recipe, auth: authModel, path: $path)
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUserRecipes(userId: authModel.profile.uid)
            }
        }
    }
}

#Preview {
    ProfileView(
        test: true,
        authModel: AuthModel(testProfile: true),
        path: Binding<NavigationPath>(
            get: { return NavigationPath() },
            set: { _ in }
        )
    )
}
